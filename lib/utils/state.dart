import 'package:flutter/material.dart';

import 'package:jobhop/company/models/models.dart';


abstract class AppModel extends ChangeNotifier {
  void setUserBasic(StudentUser user, String token);
  void setUserFull(StudentUser user, String token);
  void setIsDemo(bool isDemo);

  StudentUser? get user => user;
  bool get isDemo => isDemo;
}

class AppModelImplementation extends AppModel {
  StudentUser? _user;
  bool _isDemo = false;

  AppModelImplementation();

  @override
  bool get isDemo => _isDemo;

  @override
  void setIsDemo(bool isDemo) {
    _isDemo = isDemo;
  }

  @override
  StudentUser? get user => _user;

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
