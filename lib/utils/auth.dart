import 'package:jobhop/company/models/models.dart';
import 'package:jobhop/utils/state.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
}
