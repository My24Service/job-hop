import 'dart:async';
import 'dart:convert' show json;

import "package:http/http.dart" as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth.dart';


class Google {
  late GoogleSignIn _googleSignIn;
  late GoogleSignInAccount? _currentUser;

  Google(GoogleSignIn googleSignIn) {
    this._googleSignIn = googleSignIn;
  }

  Future<bool> login() async {
    try {
      await _googleSignIn.signIn().then((result) {
        result!.authentication.then((googleKey) async {
          final registerByTokenEndpoint = Uri(
            scheme: 'https',
            host: 'jobhop.my24service-dev.com',
            path: '/register-by-token/google-oauth2/',
          );

          final Map<String, String?> body = {
            'access_token': googleKey.accessToken,
            'email': _currentUser!.email,
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
          await auth.storeBackend('google');
        });
      });

      return true;
    } catch (error) {
      print(error);

      return false;
    }
  }

  void handleAccountLogin(GoogleSignInAccount? account) async {
    _currentUser = account;
  }

  Future<void> logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    _googleSignIn.disconnect();
    await prefs.remove('email');
    await prefs.remove('username');
    await prefs.remove('token');
  }
}
