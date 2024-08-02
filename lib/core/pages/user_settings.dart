import 'package:flutter/material.dart';
import 'package:jobhop/company/api/api.dart';
import 'package:jobhop/company/models/models.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:jobhop/core/widgets/widgets.dart';
// import 'package:jobhop/utils/generic.dart';
// import 'package:jobhop/company/pages/home.dart';

class UserSettingsPage extends StatefulWidget {
  @override
  _UserSettingsPageState createState() =>
      _UserSettingsPageState();
}

class _UserSettingsPageState extends State<UserSettingsPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _notifyPushDayBeforeOrderStarts = false;
  late UserSettings _userSettings;

  @override
  void initState() {
    super.initState();
    _doAsync();
  }

  _doAsync() async {
    _userSettings = await companyApi.getUserSettings();
    print(_userSettings.settings);
    _notifyPushDayBeforeOrderStarts = _userSettings.settings!['NOTIFY_PUSH_DAY_BEFORE_ORDER_STARTS'];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('user_settings.app_bar_title'.tr()),
        ),
        body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: Container(
                margin: new EdgeInsets.symmetric(horizontal: 20.0),
                child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      createHeader('user_settings.header_settings'.tr()),
                      Form(
                          key: _formKey,
                          child: _buildForm()
                      ),
                    ]
                )
            )
        )
    );
  }

  Widget _buildForm() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('user_settings.info_notify_push_day_before_order_starts'.tr()),
          Checkbox(
            value: _notifyPushDayBeforeOrderStarts,
            onChanged: (bool? value) {
              setState(() {
                _notifyPushDayBeforeOrderStarts = value!;
              });
            },
          ),
          SizedBox(
            height: 20.0,
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
              ),
              child: Text('user_settings.button_save'.tr()),
              onPressed: () async {
                if (this._formKey.currentState!.validate()) {
                  this._formKey.currentState!.save();

                  final bool result = await companyApi.updateUserSettings({
                    'NOTIFY_PUSH_DAY_BEFORE_ORDER_STARTS': _notifyPushDayBeforeOrderStarts
                  });

                  if (result) {
                    createSnackBar(context, 'user_settings.snackbar_saved'.tr());
                  } else {
                    createSnackBar(context, 'user_settings.snackbar_error_saving'.tr());
                  }

                  setState(() {});
                }
              }
          )
        ]
    );
  }
}
