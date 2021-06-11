import 'dart:ui';

Locale? lang2locale(String lang) {
  if (lang == 'nl') {
    return Locale('nl', 'NL');
  }

  if (lang == 'en') {
    return Locale('en', 'US');
  }

  return null;
}

String formatDate(DateTime date) {
  return "${date.toLocal()}".split(' ')[0];
}
