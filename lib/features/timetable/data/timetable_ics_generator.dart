import 'dart:convert';

import '../domain/timetable_models.dart';

/// Libellés traduits insérés dans les événements.
typedef IcsLabels = ({String teacher, String room, String reminder, String cancelled});

/// Générateur iCalendar (RFC 5545) : importable dans Google Agenda, Apple Calendrier et Outlook.
///
/// Heures en UTC (suffixe Z), lignes terminées par CRLF et repliées à 75 octets,
/// textes échappés, UID stables (une réimportation met à jour au lieu de dupliquer)
/// et rappel avant chaque cours non annulé.
class TimetableIcsGenerator {
  final String domain;
  const TimetableIcsGenerator({this.domain = 'uniparent.aframgabon.com'});

  String generate({
    required List<TimetableSlot> slots,
    required String calendarName,
    required IcsLabels labels,
    int alarmMinutes = 15,
    bool includeCancelled = true,
    DateTime? now,
  }) {
    final stamp = _utc(now ?? DateTime.now());
    final lines = <String>[
      'BEGIN:VCALENDAR',
      'VERSION:2.0',
      'PRODID:-//AFRAM//UniParent//FR',
      'CALSCALE:GREGORIAN',
      'METHOD:PUBLISH',
      'X-WR-CALNAME:${escape(calendarName)}',
      'X-WR-TIMEZONE:Africa/Libreville',
    ];
    final sorted = [...slots]..sort((a, b) => a.debut.compareTo(b.debut));
    for (final s in sorted) {
      if (s.cancelled && !includeCancelled) continue;
      final description = [
        '${labels.teacher} : ${s.enseignant}',
        '${labels.room} : ${s.salle} — ${s.campus}',
        if (s.cancelled) labels.cancelled,
        if (s.motif != null && s.motif!.isNotEmpty) s.motif!,
      ].join('\n');
      lines.addAll([
        'BEGIN:VEVENT',
        'UID:${s.id}@$domain',
        'DTSTAMP:$stamp',
        'DTSTART:${_utc(s.debut)}',
        'DTEND:${_utc(s.fin)}',
        'SUMMARY:${escape('${s.matiere} (${s.code})')}',
        'LOCATION:${escape('${s.salle} — ${s.campus}')}',
        'DESCRIPTION:${escape(description)}',
        'CATEGORIES:${escape(s.code)}',
        'STATUS:${s.cancelled
            ? 'CANCELLED'
            : s.postponed
            ? 'TENTATIVE'
            : 'CONFIRMED'}',
        'TRANSP:OPAQUE',
        if (!s.cancelled && alarmMinutes > 0) ...[
          'BEGIN:VALARM',
          'ACTION:DISPLAY',
          'DESCRIPTION:${escape('${labels.reminder} : ${s.matiere}')}',
          'TRIGGER:-PT${alarmMinutes}M',
          'END:VALARM',
        ],
        'END:VEVENT',
      ]);
    }
    lines.add('END:VCALENDAR');
    return '${lines.map(fold).join('\r\n')}\r\n';
  }

  static String _utc(DateTime d) {
    final u = d.toUtc();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${u.year.toString().padLeft(4, '0')}${two(u.month)}${two(u.day)}T${two(u.hour)}${two(u.minute)}${two(u.second)}Z';
  }

  /// Échappement des valeurs TEXT (§3.3.11) : antislash, point-virgule, virgule, saut de ligne.
  static String escape(String value) => value.replaceAll('\\', '\\\\').replaceAll(';', '\\;').replaceAll(',', '\\,').replaceAll(RegExp(r'\r?\n'), '\\n');

  /// Repli des lignes à 75 octets (§3.1) sans couper un caractère UTF-8.
  static String fold(String line) {
    if (utf8.encode(line).length <= 75) return line;
    final out = StringBuffer();
    var octets = 0;
    var limit = 75;
    for (final rune in line.runes) {
      final char = String.fromCharCode(rune);
      final size = utf8.encode(char).length;
      if (octets + size > limit) {
        out.write('\r\n ');
        octets = 0;
        limit = 74; // l'espace de continuation compte dans les 75 octets
      }
      out.write(char);
      octets += size;
    }
    return out.toString();
  }
}
