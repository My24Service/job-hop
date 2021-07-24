import 'dart:convert';

import 'package:jobhop/utils/auth.dart';
import 'package:jobhop/utils/generic.dart';
import 'package:jobhop/core/app_config.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'package:jobhop/utils/state.dart';

GetIt getIt = GetIt.instance;

mixin ApiMixin {
  String getUrl(String path) {
    final isDemo = getIt<AppModel>().isDemo;
    final String baseUrl = isDemo ? config.demoApiBaseUrl : config.apiBaseUrl;
    return "https://$baseUrl$path";
  }

  Future<Map<String, String>> getHeaders() async {
    Map<String, String> headers = {"Content-Type": "application/json; charset=UTF-8"};
    String? token = await getToken();

    if (token != null) {
      headers.addAll({'Authorization': 'Token $token'});
    }

    return headers;
  }
}

class CoreApi with ApiMixin {
  // default and setable for tests
  http.Client _httpClient = new http.Client();

  set httpClient(http.Client client) {
    _httpClient = client;
  }

  Future<Map<String, dynamic>?> attemptLogIn(String username, String password) async {
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

CoreApi coreApi = CoreApi();
