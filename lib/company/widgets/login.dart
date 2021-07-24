import 'package:flutter/material.dart';
import 'package:jobhop/company/api/api.dart';
import 'package:jobhop/company/pages/home.dart';
import 'package:jobhop/core/widgets/widgets.dart';
import 'package:jobhop/utils/auth.dart';
import 'package:jobhop/utils/generic.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:jobhop/core/api/api.dart';


class LoginView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    _addListeners();

    return ModalProgressHUD(child: Container(
      padding: EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildTextFields(),
            Divider(),
            _buildButtons(),
          ],
        ),
      ) ,
    ), inAsyncCall: _saving);
  }

  final TextEditingController _emailFilter = new TextEditingController();
  final TextEditingController _passwordFilter = new TextEditingController();
  String _username = "";
  String _password = "";
  bool _saving = false;

  _addListeners() {
    _emailFilter.addListener(_emailListen);
    _passwordFilter.addListener(_passwordListen);
  }

  void _emailListen() {
    if (_emailFilter.text.isEmpty) {
      _username = "";
    } else {
      _username = _emailFilter.text;
    }
  }

  void _passwordListen() {
    if (_passwordFilter.text.isEmpty) {
      _password = "";
    } else {
      _password = _passwordFilter.text;
    }
  }

  Widget _buildTextFields() {
    return Container(
      child: Column(
        children: <Widget>[
          new Container(
            child: TextField(
              controller: _emailFilter,
              decoration: InputDecoration(
                  labelText: 'login.username'.tr()
              ),
            ),
          ),
          new Container(
            child: TextField(
              controller: _passwordFilter,
              decoration: InputDecoration(
                  labelText: 'login.password'.tr()
              ),
              obscureText: true,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildButtons() {
    return Container(
        alignment: Alignment.center,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              createBlueElevatedButton(
                  'login.button_login'.tr(), _loginPressed),
              SizedBox(height: 30),
              createBlueElevatedButton(
                  'login.button_forgot_password'.tr(), _passwordReset,
                  primaryColor: Colors.redAccent
              ),
              SizedBox(height: 10),
              createBlueElevatedButton(
                  'login.button_register'.tr(), _register,
                  primaryColor: Colors.green
              ),
            ],
          ),
    );
  }

  _passwordReset () async {
    final url = companyApi.getUrl('/company/users/password-reset/#users/reset-password');
    launch(url);
  }

  _register () async {
    final url = companyApi.getUrl('/company/users/student/register/');
    launch(url);
  }

  _loginPressed () async {
    setState(() {
      _saving = true;
    });

    Map<String, dynamic>? result = await coreApi.attemptLogIn(_username, _password);

    if (result == null) {
      setState(() {
        _saving = false;
      });

      displayDialog(
          context,
          'login.dialog_error_title'.tr(),
          'login.dialog_error_content'.tr()
      );
      return;
    }

    await auth.storeUser(result);
    await auth.storeBackend('jobhop');

    // request permissions
    await requestFCMPermissions();

    // navigate to home
    final page = JobHopHome();

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => page
        )
    );
  }
}
