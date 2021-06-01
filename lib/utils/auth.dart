import 'package:jobhop/company/models/models.dart';
import 'package:jobhop/utils/state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth {
  Future<bool> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.remove('email');
    await prefs.remove('username');
    await prefs.remove('token');

    return true;
  }

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
}
