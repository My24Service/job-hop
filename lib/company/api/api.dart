import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:jobhop/utils/auth.dart';
// import 'package:jobhop/utils/generic.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:easy_localization/easy_localization.dart';
import 'package:jobhop/company/models/models.dart';
import 'package:jobhop/core/api/api.dart';

class CompanyApi with ApiMixin {
  // default and settable for tests
  http.Client _httpClient = new http.Client();

  set httpClient(http.Client client) {
    _httpClient = client;
  }

  Future<bool> deleteMe() async {
    final int? userPk = await auth.getUserFieldInt('userPk');

    if (userPk == null) {
      return false;
    }

    final String url = getUrl('/company/user/delete-me/$userPk/');
    final response = await _httpClient.delete(
        Uri.parse(url),
        headers: await getHeaders()
    );

    if (response.statusCode == 204) {
      return true;
    }

    return false;
  }

  Future<StudentUser> fetchStudentUserMe() async {
    final String url = getUrl('/company/users/student/profile/me/');
    final response = await _httpClient.get(
        Uri.parse(url),
        headers: await getHeaders()
    );

    if (response.statusCode == 200) {
      return StudentUser.fromJson(json.decode(response.body));
    }

    if (response.statusCode == 401) {
      throw JobhopInvalidTokenException('invalid token');
    }

    String error = '${response.statusCode}, ${response.body}';

    throw Exception("${'generic.exception_fetch'.tr()} ($error)");
  }

  Future<bool> updateStudentUserMe(StudentUser user) async {
    final String url = getUrl('/company/users/student/profile/me/');

    final Map studentUserBody = {
      'street': user.studentUser!.street,
      'house_number': user.studentUser!.houseNumber,
      'house_number_addition': user.studentUser!.houseNumberAddition,
      'postal': user.studentUser!.postal,
      'city': user.studentUser!.city,
      'country_code': user.studentUser!.countryCode,
      'mobile': user.studentUser!.mobile,
      'remarks': user.studentUser!.remarks,
      'iban': user.studentUser!.iBan,
      'info': user.studentUser!.info,
      'gender': user.studentUser!.gender,
      'dob': user.studentUser!.dayOfBirth,
      'drivers_licence': user.studentUser!.driversLicence,
      'drivers_licence_type': user.studentUser!.driversLicenceType,
      'box_truck': user.studentUser!.boxTruck,
      'bsn': user.studentUser!.bsn,
      'first_time_profile': user.studentUser!.isFirstTimeProfile,
      'vaccinated': user.studentUser!.vaccinated,
      if (user.studentUser!.picture != null)
        'picture': user.studentUser!.picture,
    };

    final Map body = {
      'email': user.email,
      'first_name': user.firstName,
      'last_name': user.lastName,
      'student_user': studentUserBody,
    };

    final response = await _httpClient.put(
        Uri.parse(url),
        body: json.encode(body),
        headers: await getHeaders()
    );

    if (response.statusCode == 200) {
      return true;
    }

    throw Exception("Error updating info");
  }

  Future<bool> postDeviceToken() async {
    final Map<String, String> envVars = Platform.environment;

    if (envVars['TESTING'] != null) {
      return true;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();

    final int? userPk = prefs.getInt('userPk');
    final bool? isAllowed = prefs.getBool('fcm_allowed');

    if (userPk == null || isAllowed == null) {
      return false;
    }

    if (!isAllowed) {
      return false;
    }

    final url = getUrl('/company/user-device-token/');

    await Firebase.initializeApp();
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? messagingToken = await messaging.getToken();

    final Map body = {
      "user": userPk,
      "device_token": messagingToken
    };

    final response = await _httpClient.post(
      Uri.parse(url),
      body: json.encode(body),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      return true;
    }

    if (response.statusCode == 401) {
      throw JobhopInvalidTokenException('invalid token');
    }

    String error = '${response.statusCode}, ${response.body}';

    throw Exception("${'generic.exception_fetch'.tr()} ($error)");
  }

  // Future<Map<String, dynamic>?> createDemoUser() async {
  //   final Map<String, String> envVars = Platform.environment;
  //
  //   if (envVars['TESTING'] != null) {
  //     return null;
  //   }
  //
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //
  //   final bool isAllowed = prefs.getBool('fcm_allowed')!;
  //
  //   if (!isAllowed) {
  //     return null;
  //   }
  //
  //   final url = getUrl('/company/setup-demo-user-temps/');
  //
  //   await Firebase.initializeApp();
  //   FirebaseMessaging messaging = FirebaseMessaging.instance;
  //   String? messagingToken = await messaging.getToken();
  //
  //   final Map body = {
  //     "secret": encryptText(messagingToken!)
  //   };
  //
  //   final response = await _httpClient.post(
  //     Uri.parse(url),
  //     body: json.encode(body),
  //     headers: await getHeaders(),
  //   );
  //
  //   if (response.statusCode == 200) {
  //     return json.decode(response.body);
  //   }
  //
  //   return null;
  // }
  //
  // Future<bool> createDemoEnvironment() async {
  //   final url = getUrl('/company/setup-demo-environment-temps/');
  //
  //   final response = await _httpClient.post(
  //     Uri.parse(url),
  //     body: json.encode({}),
  //     headers: await getHeaders(),
  //   );
  //
  //   if (response.statusCode == 200) {
  //     return true;
  //   }
  //
  //   return false;
  // }
  //
  Future<UserSettings> getUserSettings() async {
    final url = getUrl('/company/user-settings/');

    final response = await _httpClient.get(
      Uri.parse(url),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      return UserSettings.fromJson(json.decode(response.body));
    }

    throw Exception('User settings could not be loaded');
  }

  Future<bool> updateUserSettings(Map<String, dynamic> settings) async {
    final url = getUrl('/company/user-settings/');

    final response = await _httpClient.put(
      Uri.parse(url),
      body: json.encode({
        'settings': settings
      }),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      return true;
    }

    return false;
  }

}

CompanyApi companyApi = CompanyApi();
