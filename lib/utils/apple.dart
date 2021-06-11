import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'package:jobhop/utils/auth.dart';

class Apple {
  Future<void> logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.remove('email');
    await prefs.remove('username');
    await prefs.remove('token');
  }

  Future<bool> login() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      webAuthenticationOptions: WebAuthenticationOptions(
        clientId: 'JobHop',
        redirectUri: Uri.parse(
            'https://jobhop.my24service-dev.com/sign_in_with_apple'
        ),
      ),
    );

    // This is the endpoint that will convert an authorization code obtained
    // via Sign in with Apple into a session in your system
    final signInWithAppleEndpoint = Uri(
      scheme: 'https',
      host: 'jobhop.my24service-dev.com',
      path: '/api/login/social/token_user/',
    );

    final Map<String, String> body = {
      'provider': 'apple-id',
      'code': credential.authorizationCode,
    };

    final Map<String, String> headers = {"Content-Type": "application/json; charset=UTF-8"};

    final response = await http.Client().post(
      signInWithAppleEndpoint,
      body: json.encode(body),
      headers: headers,
    );

    // If we got this far, a session based on the Apple ID credential has been created in your system,
    // and you can now set this as the app's session
    if(response.statusCode != 200) {
      return false;
    }

    Map<String, dynamic> parsedResponse = json.decode(response.body);

    await auth.storeUser(parsedResponse);
    await auth.storeBackend('apple');

    return true;
  }
}
