import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:jobhop/core/widgets/widgets.dart';
import 'package:jobhop/mobile/pages/assigned_list.dart';
import 'package:jobhop/utils/auth.dart';
import 'package:jobhop/utils/generic.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'package:jobhop/company/api/api.dart';

GetIt getIt = GetIt.instance;

class DemoPage extends StatefulWidget {
  @override
  State createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  bool _inAsyncCall = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        child: Align(
          alignment: Alignment.center,
          child: _buildBody(),
        ),
        inAsyncCall: _inAsyncCall
      )
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        createHeader('Tijdelijke Job-Hop omgeving'),
        Text('demo.text1'.tr()),
        SizedBox(height: 10),
        Text('demo.text2'.tr()),
        SizedBox(height: 10),
        Text('demo.text3'.tr()),
        SizedBox(height: 50),
        ElevatedButton(
            child: Text('generic.action_continue'.tr()),
            onPressed: () async {
              _inAsyncCall = true;
              setState(() {});

              // request permissions
              await requestFCMPermissions();

              // create demo user and environment
              final Map<String, dynamic>? result = await companyApi.createDemoUser();

              if (result == null) {
                _inAsyncCall = false;
                setState(() {});

                return displayDialog(
                  context,
                  'demo.error_title_creating_user'.tr(),
                  'demo.error_content_creating_user'.tr()
                );
              }

              await Firebase.initializeApp();
              FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
                if (message.data.containsKey('demo_okay')) {
                  // store user
                  await auth.storeUser(message.data['user']);

                  // okay to create demo environment
                  final bool result = await companyApi
                      .createDemoEnvironment();

                  if (result == false) {
                    _inAsyncCall = false;
                    setState(() {});

                    return displayDialog(
                        context,
                        'demo.error_title_creating_environment'.tr(),
                        'demo.error_content_creating_environment'.tr()
                    );
                  }

                  _inAsyncCall = false;
                  setState(() {});

                  Widget button = TextButton(
                      child: Text('generic.action_continue'.tr()),
                      onPressed: () {
                        final page = AssignedOrderListPage();
                        Navigator.pushReplacement(
                            context, MaterialPageRoute(builder: (context) => page)
                        );
                      }
                  );

                  AlertDialog alert = AlertDialog(
                    title: Text('demo.alert_title_environment_created'.tr()),
                    content: Text('alert_content_environment_created'.tr()),
                    actions: [
                      button,
                    ],
                  );

                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      return alert;
                    },
                  );
                }
              });
            }
        )
      ],
    );
  }
}
