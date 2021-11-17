import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';

import 'package:jobhop/company/api/api.dart';
import 'package:jobhop/company/models/models.dart';
import 'package:jobhop/utils/state.dart';
import 'generic.dart';

GetIt getIt = GetIt.instance;

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

    final int? userPk = prefs.getInt('userPk');
    final String? email = prefs.getString('email');
    final String? username = prefs.getString('username');
    final String? token = prefs.getString('token');

    if (userPk == null || email == null || username == null || token == null) {
      return null;
    }

    // fetch from backend and store in state
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

    return getIt<AppModel>().user!;
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

    prefs.remove('userPk');
    prefs.remove('email');
    prefs.remove('username');
    prefs.remove('token');
    prefs.remove('isFirstTimeProfile');

    return true;
  }

}

Auth auth = Auth();
