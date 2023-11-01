import 'package:flutter/material.dart';
import 'package:jobhop/mobile/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:jobhop/core/secret.dart';
import 'package:jobhop/utils/state.dart';

GetIt getIt = GetIt.instance;

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

Future<String> getLocaleString() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? preferedLanguageCode = prefs.getString('preferedLanguageCode');

  if(preferedLanguageCode == null) {
    preferedLanguageCode = 'nl';
  }
  print('preferedLanguageCode: $preferedLanguageCode');
  return preferedLanguageCode;
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
  if (prefs.containsKey('token')) {
    return prefs.getString('token')!;
  }

  return null;
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

Future<void> setIsDemo() async {
  getIt<AppModel>().setIsDemo(true);
}

Future<void> setIsNotDemo() async {
  getIt<AppModel>().setIsDemo(false);
}

// Future<void> requestFCMPermissions() async {
//   // request permissions
//   SharedPreferences _prefs = await SharedPreferences.getInstance();
//
//   if (!_prefs.containsKey('fcm_allowed')) {
//     bool isAllowed = false;
//
//     await Firebase.initializeApp();
//     FirebaseMessaging messaging = FirebaseMessaging.instance;
//     NotificationSettings settings = await messaging.requestPermission(
//       alert: true,
//       sound: true,
//       announcement: false,
//       badge: false,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//     );
//
//     // are we allowed?
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       isAllowed = true;
//     }
//
//     _prefs.setBool('fcm_allowed', isAllowed);
//   }
// }

String encryptText(String text) {
  final key = encrypt.Key.fromUtf8(secret.key);
  // print(base64Url.encode(key.bytes));
  final fernet = encrypt.Fernet(key);
  final encrypter = encrypt.Encrypter(fernet);
  final encryptedToken = encrypter.encrypt(text);

  return encryptedToken.base64;
}

void createCalendarEvent(TripOrder tripOrder) {
  final String title = 'calendar_title'.tr();
  final String description = 'calendar_description'.tr(
      namedArgs: {'name': tripOrder.name, 'date': tripOrder.date});
  final String location = '${tripOrder.address}, ${tripOrder.postal}, ${tripOrder.postal}, ${tripOrder.countryCode}';

  final Event event = Event(
      title: title,
      description: description,
      location: location,
      startDate: tripOrder.startDate,
      endDate: tripOrder.endDate
  );

  Add2Calendar.addEvent2Cal(event);
}

bool isNumeric(String? s) {
  if(s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}

bool isValidBsn(String bsn) {
  /*
    Validator based on a variation of the Dutch check-digit validation used for checking IBAN.
    This variation is used for BSN.
    For more information visit https://nl.wikipedia.org/wiki/Elfproef#Burgerservicenummer
    :param value: customer service number (BSN), must be 9 digits
    :return: True if valid, False if invalid
    */
  int bsnLen = bsn.length;
  if (bsnLen != 9 || !isNumeric(bsn)) {
    return false;
  }

  int total = 0;
  for (int index=0; index<8; index++) {
    String t = bsn[index];
    total += int.parse(t) * (9 - index);
  }

  int lastNumber = int.parse(bsn[8]);

  // Validate if the remainder of the total divided by 11 is equal to the last number in the BSN
  if (total % 11 != lastNumber) {
    return false;
  }

  return true;
}
