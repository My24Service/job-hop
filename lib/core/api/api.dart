import 'dart:convert';

import 'package:jobhop/utils/generic.dart';
import 'package:jobhop/core/app_config.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'package:jobhop/utils/state.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../company/models/models.dart';

GetIt getIt = GetIt.instance;

mixin ApiMixin {
  String getUrl(String path) {
    final isDemo = getIt<AppModel>().isDemo;
    final String baseUrl = isDemo ? config.demoApiBaseUrl : config.apiBaseUrl;
    return "https://$baseUrl/api$path";
  }

  Future<Map<String, String>> getHeaders() async {
    Map<String, String> headers = {"Content-Type": "application/json; charset=UTF-8"};
    String? token = await getToken();

    if (token != null) {
      headers.addAll({'Authorization': 'Bearer $token'});
    }

    return headers;
  }
}

class CoreApi with ApiMixin {
  // default and setable for tests
  http.Client _httpClient = new http.Client();
  SharedPreferences? _prefs;

  set httpClient(http.Client client) {
    _httpClient = client;
  }

  Future<SlidingToken?> attemptLogIn(String username, String password) async {
    Map<String, String> allHeaders = {"Content-Type": "application/json; charset=UTF-8"};
    final url = getUrl('/jwt-token/');
    final res = await _httpClient.post(
        Uri.parse(url),
        body: json.encode({
          "username": username,
          "password": password
        }),
        headers: allHeaders
    );

    if (res.statusCode == 200) {
      SlidingToken token = SlidingToken.fromJson(json.decode(res.body));

      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token.token!);

      return token;
    }

    return null;
  }

  Future<dynamic> getUserInfo() async {
    if(_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }

    final url = getUrl('/company/user-info-me/');
    final res = await _httpClient.get(
        Uri.parse(url),
        headers: await getHeaders()
    );

    if (res.statusCode == 200) {
      var userInfoData = json.decode(res.body);
      return userInfoData;
    }

    return null;
  }

  Future<Map<String, dynamic>?> attemptLogInOld(String username, String password) async {
    final url = getUrl('/rest-auth/login/');
    final Map<String, String> headers = {"Content-Type": "application/json; charset=UTF-8"};
    final Map<String, String?> body = {
      'username': username,
      'password': password,
    };

    final response = await _httpClient.post(
      Uri.parse(url),
      body: json.encode(body),
      headers: headers,
    );

    if(response.statusCode != 200) {
      return null;
    }

    // make response in a way auth.storeUser expects
    Map<String, dynamic> parsedResponse = json.decode(response.body);
    Map<String, dynamic> result = {
      'id': parsedResponse['user']['id'],
      'email': parsedResponse['user']['email'],
      'username': parsedResponse['user']['username'],
      'token': parsedResponse['key']
    };

    return result;
  }

}

class JobhopInvalidTokenException implements Exception {
  String cause;
  JobhopInvalidTokenException(this.cause);
}

CoreApi coreApi = CoreApi();
