import 'package:intl/intl.dart';

/// Formatage localisé (montants en FCFA entiers, dates, heures).
class Fmt {
  Fmt._();

  static String get _locale => Intl.getCurrentLocale().startsWith('en') ? 'en' : 'fr_FR';

  /// Les montants sont des entiers (plus petite unité). XAF n'a pas de décimales.
  static String money(num amount, [String currency = 'XAF']) {
    final f = NumberFormat.decimalPattern(_locale);
    final label = currency == 'XAF' ? 'FCFA' : currency;
    return '${f.format(amount.round())} $label'.replaceAll(' ', ' ').replaceAll(' ', ' ');
  }

  static String date(DateTime d) => DateFormat.yMMMMd(_locale).format(d.toLocal());
  static String shortDate(DateTime d) => DateFormat('dd/MM/yyyy').format(d.toLocal());
  static String dayMonth(DateTime d) => DateFormat.MMMd(_locale).format(d.toLocal());
  static String weekday(DateTime d) => toBeginningOfSentenceCase(DateFormat.EEEE(_locale).format(d.toLocal()));
  static String time(DateTime d) => DateFormat.Hm(_locale).format(d.toLocal());
  static String dateTime(DateTime d) => '${date(d)} · ${time(d)}';
  static String monthYear(DateTime d) => toBeginningOfSentenceCase(DateFormat.yMMMM(_locale).format(d.toLocal()));

  static String grade(num value, [num bareme = 20]) =>
      '${NumberFormat('0.##', _locale).format(value)} / ${NumberFormat('0.##', _locale).format(bareme)}';

  static String percent(num? value) => value == null ? '—' : '${NumberFormat('0.#', _locale).format(value)} %';

  static String relative(DateTime d) {
    final diff = DateTime.now().difference(d.toLocal());
    final en = _locale == 'en';
    if (diff.inMinutes < 1) return en ? 'just now' : "à l'instant";
    if (diff.inMinutes < 60) return en ? '${diff.inMinutes} min ago' : 'il y a ${diff.inMinutes} min';
    if (diff.inHours < 24) return en ? '${diff.inHours} h ago' : 'il y a ${diff.inHours} h';
    if (diff.inDays < 7) return en ? '${diff.inDays} d ago' : 'il y a ${diff.inDays} j';
    return shortDate(d);
  }
}

DateTime? parseDate(Object? v) => v == null ? null : DateTime.parse(v as String);
