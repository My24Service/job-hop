import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:jobhop/company/widgets/profile.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text('profile.app_bar_title'.tr()),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        },
        child: ProfileFormWidget(),
      )
    );
  }
}
