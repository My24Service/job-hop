import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:jobhop/company/models/models.dart';
import 'package:jobhop/utils/state.dart';
import 'apple.dart';
import 'facebook.dart';
import 'google.dart';

GoogleSignIn googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
  ],
);

class Auth {
  Future<String?> getUserToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('token');

    return token;
  }

  Future<bool> storeUser(Map<String, dynamic> userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    AppStateModel state = AppStateModel();

    await prefs.setString('email', userData['email']);
    await prefs.setString('username', userData['username']);
    await prefs.setString('token', userData['token']);

    StudentUser user = StudentUser(
      email: userData['email'],
      username: userData['username'],
      token: userData['token'],
    );

    state.setUser(user);

    return true;
  }

  Future<bool> storeBackend(String backend) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('backend', backend);

    return true;
  }

  Future<String?> getBackend() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? backend = prefs.getString('backend');

    return backend;
  }

  Future<bool> logout() async {
    final String? _backend = await getBackend();

    switch(_backend) {
      case 'apple':
        Apple _apple = Apple();
        await _apple.logOut();
        break;
      case 'facebook':
        Facebook _facebook = Facebook();
        await _facebook.logOut();
        break;
      case 'google':
        Google _google = Google(googleSignIn);
        await _google.logOut();
    }

    return true;
  }

}

Auth auth = Auth();
