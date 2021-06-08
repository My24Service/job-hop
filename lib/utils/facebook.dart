import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth.dart';

class Facebook {
  Map<String, dynamic>? _userData;

  Future<bool> login() async {
    final LoginResult result = await FacebookAuth.instance.login(); // by the fault we request the email and the public profile

    if (result.status == LoginStatus.success) {
      // get the user data
      // by default we get the userId, email,name and picture
      final userData = await FacebookAuth.instance.getUserData();
      // final userData = await FacebookAuth.instance.getUserData(fields: "email,birthday,friends,gender,link");
      AccessToken? _accessToken = result.accessToken;
      _userData = userData;

      final registerByTokenEndpoint = Uri(
        scheme: 'https',
        host: 'jobhop.my24service-dev.com',
        path: '/register-by-token/facebook/',
      );

      final Map<String, String> body = {
        'access_token': _accessToken!.token,
        'email': userData['email'],
      };

      final Map<String, String> headers = {"Content-Type": "application/json; charset=UTF-8"};

      final response = await http.Client().post(
        registerByTokenEndpoint,
        body: json.encode(body),
        headers: headers,
      );

      if(response.statusCode != 200) {
        return false;
      }

      Map<String, dynamic> parsedResponse = json.decode(response.body);

      if(parsedResponse['result'] == false) {
        return false;
      }

      final Auth auth = Auth();
      await auth.storeUser(parsedResponse);
      await auth.storeBackend('facebook');

      return true;
    } else {
      print(result.status);
      print(result.message);

      return false;
    }
  }

  Future<void> logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await FacebookAuth.instance.logOut();
    await prefs.remove('email');
    await prefs.remove('username');
    await prefs.remove('token');
  }
}
