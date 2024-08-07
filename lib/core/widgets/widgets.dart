import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:jobhop/order/models/models.dart';


Future<dynamic> displayDialog(context, title, text) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: Text(title),
            content: Text(text)
        );
      }
  );
}

Widget createHeader(String text) {
  return Container(child: Column(
    children: [
      SizedBox(
        height: 10.0,
      ),
      Text(text, style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.grey
      )),
      SizedBox(
        height: 10.0,
      ),
    ],
  ));
}

createSnackBar(BuildContext context, String content) {
  final snackBar = SnackBar(
    content: Text(content),
    duration: Duration(seconds: 1),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

Widget errorNotice(String message) {
  return Center(
      child: Column(
        children: [
          SizedBox(height: 30),
          Text(message),
          SizedBox(height: 30),
        ],
      )
  );
}

Widget errorNoticeWithReload(String message, dynamic reloadBloc, dynamic reloadEvent) {
  return RefreshIndicator(
      child: ListView(
        children: [
          errorNotice(message),
        ],
      ),
      onRefresh: () {
        return Future.delayed(
            Duration(milliseconds: 5),
                () {
              reloadBloc.add(reloadEvent);
            }
        );
      }
  );
}

Widget loadingNotice() {
  return Center(child: CircularProgressIndicator());
}

showDeleteDialogWrapper(String title, String content, BuildContext context, Function deleteFunction) {
  // set up the button
  Widget cancelButton = TextButton(
      child: Text('generic.action_cancel'.tr()),
      onPressed: () => Navigator.of(context, rootNavigator: true).pop(false) // Navigator.pop(context, false)
  );
  Widget deleteButton = TextButton(
      child: Text('generic.action_delete'.tr()),
      onPressed: () => Navigator.of(context, rootNavigator: true).pop(true) // Navigator.pop(context, false)
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(content),
    actions: [
      cancelButton,
      deleteButton,
    ],
  );

  // show the dialog
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  ).then((dialogResult) {
    if (dialogResult == null) return;

    if (dialogResult) {
      deleteFunction();
    }
  });
}

Widget buildEmptyListFeedback() {
  return Column(
    children: [
      SizedBox(height: 1),
      Text('generic.empty_table'.tr(), style: TextStyle(fontStyle: FontStyle.italic))
    ],
  );
}

ElevatedButton createBlueElevatedButton(String text, Function callback, { primaryColor=Colors.blue, onPrimary=Colors.white}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor, // background
      foregroundColor: onPrimary, // foreground
    ),
    child: new Text(text),
    onPressed: () => callback(),
  );
}

Widget createTable(List<TableRow> rows) {
  return Table(
      border: TableBorder(horizontalInside: BorderSide(width: 1, color: Colors.grey, style: BorderStyle.solid)),
      children: rows
  );
}

Widget createTableHeaderCell(String content) {
  return Padding(
    padding: EdgeInsets.all(8.0),
    child: Text(content, style: TextStyle(fontWeight: FontWeight.bold)),
  );
}

Widget createTableColumnCell(String? content) {
  return Padding(
    padding: EdgeInsets.all(4.0),
    child: Text(content != null ? content : ''),
  );
}

Widget createOrderListHeader(Order order) {
  return Table(
    children: [
      TableRow(
          children: createTableRowPair(
              'orders.info_order_date'.tr(), '${order.orderDate}')
      ),
      TableRow(
          children: createTableRowPair(
              'orders.info_order_id'.tr(), '${order.orderId}')
      ),
      TableRow(
          children: [
            SizedBox(height: 10),
            Text(''),
          ]
      )
    ],
  );
}

Widget createOrderListSubtitle(Order order) {
  return Table(
    children: [
      TableRow(
          children: createTableRowPair(
              'orders.info_customer'.tr(), '${order.orderName}'),
      ),
      TableRow(
          children: [
            SizedBox(height: 3),
            SizedBox(height: 3),
          ]
      ),
      TableRow(
          children: createTableRowPair(
              'orders.info_address'.tr(), '${order.orderAddress}'),
      ),
      TableRow(
          children: [
            SizedBox(height: 3),
            SizedBox(height: 3),
          ]
      ),
      TableRow(
          children: createTableRowPair(
              'orders.info_location'.tr(),
              '${order.orderCountryCode}-${order.orderPostal} ${order.orderCity}'),
      ),
      TableRow(
          children: [
            SizedBox(height: 3),
            SizedBox(height: 3),
          ]
      ),
      TableRow(
          children: createTableRowPair(
              'orders.info_order_type'.tr(), '${order.orderType}'),
      ),
      TableRow(
          children: [
            SizedBox(height: 3),
            SizedBox(height: 3),
          ]
      ),
      TableRow(
          children: createTableRowPair(
              'orders.info_last_status'.tr(), '${order.lastStatusFull}')
      )
    ],
  );
}

List<Widget> createTableRowPair(String label, String value) {
  return [
    Padding(
      padding: EdgeInsets.all(2),
      child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
    ),
    Padding(
      padding: EdgeInsets.all(2),
      child: Text(value),
    ),
  ];
}
