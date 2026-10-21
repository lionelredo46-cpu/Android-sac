import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

/// Base de données locale du mode démo autonome (hive_ce).
///
/// Au premier lancement, elle est remplie avec les réponses réelles de l'API
/// exportées par `scripts/export-demo-db.mjs`, recalées sur la semaine en cours
/// (les dates d'échéance, de cours et d'absence restent donc d'actualité).
/// Les actions de l'utilisateur (paiements, messages, signatures…) la modifient
/// ensuite durablement, jusqu'à une réinitialisation.
///
/// Clés : `r:<chemin>` = ressource partagée (dossier étudiant, facture…),
/// `u:<userId>:<chemin>` = ressource propre à un compte (profil, messagerie…).
class LocalDatabase {
  static const _boxName = 'uniparent_demo_db';
  static const _asset = 'assets/demo/demo_db.json';

  /// Ressources propres à chaque compte ; tout le reste est partagé entre les
  /// comptes qui suivent le même étudiant (un paiement du parent est vu par l'étudiant).
  static const _userScoped = ['/me', '/notification', '/conversations', '/appointments', '/announcements', '/calendar', '/payments/providers'];

  final Box<String> _box;
  final Map<String, Object?> _mem = {};

  LocalDatabase._(this._box);

  /// À appeler après `Hive.initFlutter()` (fait par CacheStore.open()).
  static Future<LocalDatabase> open() async {
    final db = LocalDatabase._(await Hive.openBox<String>(_boxName));
    if (db._box.get('meta') == null) await db._seed();
    return db;
  }

  Object? read(String key) => _mem.putIfAbsent(key, () {
        final raw = _box.get(key);
        return raw == null ? null : jsonDecode(raw);
      });

  Future<void> write(String key, Object? value) {
    _mem[key] = value;
    return _box.put(key, jsonEncode(value));
  }

  Iterable<String> keysStartingWith(String prefix) => _box.keys.cast<String>().where((k) => k.startsWith(prefix));

  /// Remet les données de démonstration dans leur état initial.
  Future<void> reset() async {
    await _box.clear();
    _mem.clear();
    await _seed();
  }

  static String keyFor(String path, {String? userId}) =>
      _userScoped.any(path.startsWith) && userId != null ? 'u:$userId:$path' : 'r:$path';

  Future<void> _seed() async {
    final raw = jsonDecode(await rootBundle.loadString(_asset)) as Map<String, dynamic>;
    final now = DateTime.now();
    final shift = Duration(days: _monday(now).difference(_monday(DateTime.parse(raw['exportedAt'] as String))).inDays);
    final data = shiftDates(raw, shift) as Map<String, dynamic>;
    final password = data['password'] as String;

    final entries = <String, Object?>{};
    final accounts = <Map<String, dynamic>>[];
    void addAccount(Map<String, dynamic> account, {required bool active}) {
      final login = account['login'] as Map<String, dynamic>;
      final user = login['user'] as Map<String, dynamic>;
      final id = user['id'] as String;
      accounts.add({
        'id': id,
        'email': user['email'],
        'telephone': user['telephone'],
        'role': user['role'],
        'password': password,
        'active': active,
        'twoFactorSetupRequired': login['twoFactorSetupRequired'] ?? false,
      });
      (account['responses'] as Map<String, dynamic>).forEach((path, res) {
        final key = keyFor(path, userId: id);
        final existing = entries[key] as Map<String, dynamic>?;
        // Ressource partagée : la première réponse valide l'emporte (vue du parent).
        if (existing == null || ((existing['status'] as int) >= 300 && ((res as Map)['status'] as int) < 300)) entries[key] = res;
      });
    }

    for (final a in data['accounts'] as List) {
      addAccount(a as Map<String, dynamic>, active: true);
    }
    final activation = data['activation'] as Map<String, dynamic>;
    addAccount(activation['account'] as Map<String, dynamic>, active: false);

    entries['accounts'] = accounts;
    entries['activation'] = {'code': activation['code'], 'start': activation['start'], 'userId': accounts.last['id']};
    entries['meta'] = {
      'version': data['version'],
      'seededAt': now.toUtc().toIso8601String(),
      'shiftDays': shift.inDays,
      // Semaine de référence : modèle des semaines d'emploi du temps non exportées.
      'refMonday': _monday(now).toIso8601String().substring(0, 10),
      'seq': 5000,
    };
    _mem.clear();
    await _box.putAll(entries.map((k, v) => MapEntry(k, jsonEncode(v))));
  }

  static DateTime _monday(DateTime d) {
    final l = d.toLocal();
    return DateTime.utc(l.year, l.month, l.day - (l.weekday - 1));
  }

  static final _isoDateTime = RegExp(r'^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(\.\d+)?Z$');
  static final _isoDate = RegExp(r'^\d{4}-\d{2}-\d{2}$');
  static const _fixedDates = {'dateNaissance'};

  /// Décale toutes les dates ISO d'un document JSON (sauf les dates de naissance).
  static Object? shiftDates(Object? value, Duration shift) {
    if (shift == Duration.zero) return value;
    if (value is Map) {
      return {for (final e in value.entries) e.key as String: _fixedDates.contains(e.key) ? e.value : shiftDates(e.value, shift)};
    }
    if (value is List) return [for (final v in value) shiftDates(v, shift)];
    if (value is String) {
      if (_isoDateTime.hasMatch(value)) return DateTime.parse(value).add(shift).toUtc().toIso8601String();
      if (_isoDate.hasMatch(value)) return DateTime.parse(value).add(shift).toIso8601String().substring(0, 10);
    }
    return value;
  }
}
