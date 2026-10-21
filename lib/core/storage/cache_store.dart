import 'dart:convert';

import 'package:hive_ce_flutter/hive_flutter.dart';

import '../errors/app_exception.dart';

/// Donnée accompagnée de sa provenance (réseau ou cache hors ligne).
class Cached<T> {
  final T data;
  final bool fromCache;
  final DateTime updatedAt;

  const Cached(this.data, {required this.fromCache, required this.updatedAt});
}

/// Cache hors ligne (hive_ce) : on conserve le dernier état connu de chaque
/// ressource clé (tableau de bord, notes, emploi du temps, reçus…) pour la
/// consultation sans réseau. Les données sont rattachées à l'utilisateur et
/// effacées à la déconnexion.
class CacheStore {
  static const _boxName = 'uniparent_cache';
  final Box<String> _box;

  CacheStore._(this._box);

  static Future<CacheStore> open() async {
    await Hive.initFlutter();
    return CacheStore._(await Hive.openBox<String>(_boxName));
  }

  /// Ouverture dans un répertoire donné (tests unitaires, sans plateforme).
  static Future<CacheStore> openAt(String directory) async {
    Hive.init(directory);
    return CacheStore._(await Hive.openBox<String>(_boxName));
  }

  Future<void> put(String key, Object? json) =>
      _box.put(key, jsonEncode({'at': DateTime.now().toIso8601String(), 'data': json}));

  ({Object? data, DateTime at})? read(String key) {
    final raw = _box.get(key);
    if (raw == null) return null;
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return (data: decoded['data'], at: DateTime.parse(decoded['at'] as String));
  }

  Future<void> clear() => _box.clear();

  /// Réseau d'abord ; en cas d'absence de réseau, dernier état connu.
  Future<Cached<T>> fetch<T>(
    String key,
    Future<Object?> Function() network,
    T Function(Object? json) parse,
  ) async {
    try {
      final json = await network();
      await put(key, json);
      return Cached(parse(json), fromCache: false, updatedAt: DateTime.now());
    } on AppException catch (e) {
      if (!e.isNetwork) rethrow;
      final hit = read(key);
      if (hit == null) rethrow;
      return Cached(parse(hit.data), fromCache: true, updatedAt: hit.at);
    }
  }
}
