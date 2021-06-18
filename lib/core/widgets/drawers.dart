import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:jobhop/core/pages/settings.dart';
import 'package:jobhop/mobile/pages/availability.dart';
import 'package:jobhop/utils/auth.dart';
import 'package:jobhop/mobile/pages/assigned_list.dart';
import 'package:jobhop/mobile/pages/trip.dart';
import 'package:jobhop/company/pages/home.dart';

// Drawers
Widget createDrawerHeader() {
  return Container(
    height: 80.0,
    child: DrawerHeader(
        child: Text('core.drawer_options'.tr(), style: TextStyle(color: Colors.white)),
        decoration: BoxDecoration(
            color: Colors.grey
        ),
        padding: EdgeInsets.only(top: 15, left: 15)
    ),
  );
}

ListTile listTileSettings(context) {
  final page = SettingsPage();

  return ListTile(
    title: Text('core.drawer_settings'.tr()),
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
    title: Text('core.drawer_logout'.tr()),
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

ListTile listTileTripListPage(BuildContext context, String text) {
  final page = TripListPage();

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

ListTile listTileAvailabilityListPage(BuildContext context, String text) {
  final page = AvailabilityListPage();

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
        listTileAssignedOrdersListPage(context, 'core.drawer_student_orders'.tr()),
        listTileTripListPage(context, 'core.drawer_trips'.tr()),
        listTileAvailabilityListPage(context, 'core.drawer_availability_list'.tr()),
        Divider(),
        listTileSettings(context),
        listTileLogout(context),
      ],
    ),
  );
}
