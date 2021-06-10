import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:jobhop/utils/widgets.dart';
import 'package:jobhop/utils/generic.dart';
import 'package:jobhop/company/pages/home.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() =>
      _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _preferedLanguageCode;
  bool _skipMemberList = false;

  @override
  void initState() {
    super.initState();
    _doAsync();
  }

  _doAsync() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _preferedLanguageCode = prefs.getString('prefered_language_code')!;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('settings.app_bar_title'.tr()),
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
                      createHeader('settings.header_settings'.tr()),
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
          Text('settings.info_language_code'.tr()),
          DropdownButton<String>(
            value: _preferedLanguageCode,
            items: <String>['nl', 'en'].map((String value) {
              return new DropdownMenuItem<String>(
                child: new Text(value),
                value: value,
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _preferedLanguageCode = newValue!;
              });
            },
          ),
          SizedBox(
            height: 20.0,
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.blue, // background
                onPrimary: Colors.white, // foreground
              ),
              child: Text('settings.button_save'.tr()),
              onPressed: () async {
                if (this._formKey.currentState!.validate()) {
                  this._formKey.currentState!.save();

                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setBool('skip_member_list', _skipMemberList);
                  prefs.setString('prefered_language_code', _preferedLanguageCode);

                  createSnackBar(context, 'settings.snackbar_saved'.tr());

                  context.locale = lang2locale(_preferedLanguageCode)!;

                  Navigator.pushReplacement(context,
                      new MaterialPageRoute(builder: (context) => JobHopHome())
                  );
                }
              }
          )
        ]
    );
  }
}
