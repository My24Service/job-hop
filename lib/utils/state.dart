import 'package:flutter/cupertino.dart';
import 'package:jobhop/company/models/models.dart';

class AppStateModel extends ChangeNotifier {
  late StudentUser user;

  AppStateModel();

  void setUser(StudentUser _user) {
    user = StudentUser(
        id: _user.id,
        username: _user.username,
        email: _user.email,
        token: _user.token,
    );

    notifyListeners();
  }
}
