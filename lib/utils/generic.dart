import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Locale lang2locale(String lang) {
  if (lang == 'nl') {
    return Locale('nl', 'NL');
  }

  if (lang == 'en') {
    return Locale('en', 'US');
  }

  throw("Unknown language: $lang");
}

String formatDate(DateTime date) {
  return "${date.toLocal()}".split(' ')[0];
}

Future<Locale> getLocale() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? preferedLanguageCode = prefs.getString('preferedLanguageCode');

  if(preferedLanguageCode == null) {
    preferedLanguageCode = 'nl';
  }
  print('preferedLanguageCode: $preferedLanguageCode');

  return lang2locale(preferedLanguageCode);
}

Future<void> setLocale(String langCode) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('preferedLanguageCode', langCode);
}

Future<int?> getUserPk() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final int? userPk = prefs.getInt('userPk');

  return userPk;
}

Future<String?> getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('token')!;
}

Future<void> setFirstTimeProfile() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('isFirstTimeProfile', '1');
}

Future<bool> isFirstTimeProfile() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  if(!prefs.containsKey('isFirstTimeProfile')) {
    return true;
  }

  return false;
}
