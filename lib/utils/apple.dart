import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:sign_in_with_apple/sign_in_with_apple.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Example app: Sign in with Apple'),
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: Center(
            child: SignInWithAppleButton(
              onPressed: () async {

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

                print(credential);

                // This is the endpoint that will convert an authorization code obtained
                // via Sign in with Apple into a session in your system
                final signInWithAppleEndpoint = Uri(
                  scheme: 'https',
                  host: 'jobhop.my24service-dev.com',
                  path: '/api/login/social/token/',
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
                Map<String, dynamic> parsedResponse = json.decode(response.body);

                print('token: ${parsedResponse["token"]}');
              },
            ),
          ),
        ),
      ),
    );
  }
}
