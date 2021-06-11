import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:jobhop/core/pages/settings.dart';
import 'package:jobhop/utils/auth.dart';
import 'package:jobhop/mobile/pages/assigned_list.dart';
import 'package:jobhop/company/pages/home.dart';

// Drawers
Widget createDrawerHeader() {
  return Container(
    height: 80.0,
    child: DrawerHeader(
        child: Text('utils.drawer_options'.tr(), style: TextStyle(color: Colors.white)),
        decoration: BoxDecoration(
            color: Colors.grey
        ),
        margin: EdgeInsets.all(0),
        padding: EdgeInsets.all(6.35)
    ),
  );
}

ListTile listTileSettings(context) {
  final page = SettingsPage();

  return ListTile(
    title: Text('utils.drawer_settings'.tr()),
    onTap: () {
      // close the drawer and navigate
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => page)
      );
    }, // onTap
  );
}

ListTile listTileLogout(context) {
  final page = JobHopHome();

  return ListTile(
    title: Text('utils.drawer_logout'.tr()),
    onTap: () async {
      // close the drawer and navigate
      Navigator.pop(context);

      bool loggedOut = await auth.logout();
      if (loggedOut == true) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => page)
        );
      }
    }, // onTap
  );
}

ListTile listTileAssignedOrdersListPage(BuildContext context, String text) {
  final page = AssignedOrderListPage();

  return ListTile(
    title: Text(text),
    onTap: () {
      // close the drawer and navigate
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => page)
      );
    },
  );
}

Widget createDrawer(BuildContext context) {
  return Drawer(
    child: ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.all(0),
      children: <Widget>[
        createDrawerHeader(),
        listTileAssignedOrdersListPage(context, 'utils.drawer_engineer_orders'.tr()),
        Divider(),
        listTileSettings(context),
        listTileLogout(context),
      ],
    ),
  );
}
