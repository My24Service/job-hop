import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:easy_localization/easy_localization.dart';
import 'package:jobhop/company/models/models.dart';
import 'package:jobhop/core/api/api.dart';


class CompanyApi with ApiMixin {
  // default and setable for tests
  http.Client _httpClient = new http.Client();

  set httpClient(http.Client client) {
    _httpClient = client;
  }

  Future<StudentUser> fetchStudentUser(int userPk) async {
    final String url = getUrl('/company/studentuser/$userPk/');
    final response = await _httpClient.get(
        Uri.parse(url),
        headers: await getHeaders()
    );

    if (response.statusCode == 200) {
      return StudentUser.fromJson(json.decode(response.body));
    }

    throw Exception('company.exception_fetch'.tr());
  }

  Future<bool> updateStudentUser(StudentUser user, int userPk) async {
    final String url = getUrl('/company/studentuser/$userPk/');

    final Map studentUserBody = {
      'address': user.studentUser!.address,
      'postal': user.studentUser!.postal,
      'city': user.studentUser!.city,
      'country_code': user.studentUser!.countryCode,
      'mobile': user.studentUser!.mobile,
      'remarks': user.studentUser!.remarks,
      'iban': user.studentUser!.iBan,
      'info': user.studentUser!.info,
    };

    final Map body = {
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

    throw Exception('orders.assign.exception_fetch_engineers'.tr());
  }

  Future<bool> postDeviceToken() async {
    final Map<String, String> envVars = Platform.environment;

    if (envVars['TESTING'] != null) {
      return true;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();

    final int userPk = prefs.getInt('userPk')!;
    final bool isAllowed = prefs.getBool('fcm_allowed')!;

    if (!isAllowed) {
      return false;
    }

    final url = getUrl('/company/user-device-token/');

    await Firebase.initializeApp();
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? messageingToken = await messaging.getToken();

    final Map body = {
      "user": userPk,
      "device_token": messageingToken
    };

    final response = await _httpClient.post(
      Uri.parse(url),
      body: json.encode(body),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      return true;
    }

    return false;
  }

  Future<bool> postDemoDeviceToken() async {
    final Map<String, String> envVars = Platform.environment;

    if (envVars['TESTING'] != null) {
      return true;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();

    final int userPk = prefs.getInt('userPk')!;
    final bool isAllowed = prefs.getBool('fcm_allowed')!;

    if (!isAllowed) {
      return false;
    }

    final url = getUrl('/company/demo-device-token/');

    await Firebase.initializeApp();
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? messageingToken = await messaging.getToken();

    final Map body = {
      "user": userPk,
      "device_token": messageingToken
    };

    final response = await _httpClient.post(
      Uri.parse(url),
      body: json.encode(body),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      return true;
    }

    return false;
  }
}

CompanyApi companyApi = CompanyApi();
