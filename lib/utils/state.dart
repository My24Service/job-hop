import 'package:flutter/material.dart';

import 'package:jobhop/company/models/models.dart';


abstract class AppModel extends ChangeNotifier {
  void setUserBasic(StudentUser user, String token);
  void setUserFull(StudentUser user, String token);

  StudentUser get user => user;
}

class AppModelImplementation extends AppModel {
  late StudentUser _user;

  AppModelImplementation();

  @override
  StudentUser get user => _user;

  @override
  void setUserBasic(StudentUser user, String token) {
    _user = StudentUser(
      id: user.id,
      username: user.username,
      email: user.email,
      token: token,
    );

    notifyListeners();
  }

  @override
  void setUserFull(StudentUser user, String token) {
    user.token = token;
    _user = user;

    notifyListeners();
  }
}
