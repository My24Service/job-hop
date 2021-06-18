import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';

import 'package:jobhop/company/api/api.dart';
import 'package:jobhop/company/models/models.dart';
import 'package:jobhop/utils/state.dart';
import 'apple.dart';
import 'facebook.dart';
import 'generic.dart';
import 'google.dart';

GetIt getIt = GetIt.instance;

GoogleSignIn googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
  ],
);

class Auth {
  Future<int?> getUserFieldInt(String whichField) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int? field = prefs.getInt(whichField);

    return field;
  }

  Future<String?> getUserFieldString(String whichField) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? field = prefs.getString(whichField);

    return field;
  }

  Future<StudentUser?> initState(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final bool isFirstTime = await isFirstTimeProfile();

    if (isFirstTime) {
      final int? id = prefs.getInt('userPk');
      final String? email = prefs.getString('email');
      final String? username = prefs.getString('username');
      final String? token = prefs.getString('token');

      if (id == null || email == null || username == null || token == null) {
        return null;
      }

      StudentUser user = StudentUser(
        id: id,
        email: email,
        username: username,
      );

      getIt<AppModel>().setUserBasic(user, token);

      return getIt<AppModel>().user;
    }

    // fetch from backend and store in state
    final int userPk = prefs.getInt('userPk')!;
    final String token = prefs.getString('token')!;
    StudentUser user = await companyApi.fetchStudentUser(userPk);

    getIt<AppModel>().setUserFull(user, token);

    return getIt<AppModel>().user;
  }

  Future<StudentUser> storeUser(Map<String, dynamic> userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setInt('userPk', userData['id']);
    await prefs.setString('email', userData['email']);
    await prefs.setString('username', userData['username']);
    await prefs.setString('token', userData['token']);

    StudentUser user = StudentUser(
      id: userData['id'],
      email: userData['email'],
      username: userData['username'],
    );

    getIt<AppModel>().setUserBasic(user, userData['token']);

    return getIt<AppModel>().user;
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? _backend = await getBackend();

    prefs.remove('userPk');
    prefs.remove('email');
    prefs.remove('username');
    prefs.remove('token');
    prefs.remove('isFirstTimeProfile');

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
