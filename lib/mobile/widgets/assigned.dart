import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:jobhop/core/api/api.dart';
import 'package:jobhop/mobile/pages/activity.dart';
import 'package:jobhop/core/widgets/widgets.dart';

import 'package:jobhop/mobile/blocs/assignedorder_bloc.dart';
import 'package:jobhop/mobile/models/models.dart';
import 'package:jobhop/order/models/models.dart';
import 'package:url_launcher/url_launcher.dart';


class AssignedWidget extends StatelessWidget {
  final AssignedOrder assignedOrder;

  AssignedWidget({
    required this.assignedOrder,
  });

  @override
  Widget build(BuildContext context) {
    return _showMainView(context);
  }

  Widget _showMainView(BuildContext context) {
    return Align(
        alignment: Alignment.topRight,
        child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Table(
                children: [
                  TableRow(
                      children: [
                        Text('orders.info_order_id'.tr(),
                            style: TextStyle(fontWeight: FontWeight.bold)
                        ),
                        Text("${assignedOrder.order!.orderId}"),
                      ]
                  ),
                  TableRow(
                      children: [
                        Text('orders.info_order_type'.tr(),
                            style: TextStyle(fontWeight: FontWeight.bold)
                        ),
                        Text("${assignedOrder.order!.orderType}"),
                      ]
                  ),
                  TableRow(
                      children: [
                        Text('orders.info_order_date'.tr(), style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("${assignedOrder.order!.orderDate}"),
                      ]
                  ),
                  TableRow(
                      children: [
                        Divider(),
                        SizedBox(height: 10)
                      ]
                  ),
                  TableRow(
                      children: [
                        Text('orders.info_customer'.tr(),
                            style: TextStyle(fontWeight: FontWeight.bold)
                        ),
                        Text("${assignedOrder.order!.orderName}"),
                      ]
                  ),
                  TableRow(
                      children: [
                        Text('orders.info_address'.tr(),
                            style: TextStyle(fontWeight: FontWeight.bold)
                        ),
                        Text("${assignedOrder.order!.orderAddress}"),
                      ]
                  ),
                  TableRow(
                      children: [
                        Text('orders.info_location'.tr(),
                            style: TextStyle(fontWeight: FontWeight.bold)
                        ),
                        Text("${assignedOrder.order!.orderCountryCode}-${assignedOrder.order!.orderPostal} ${assignedOrder.order!.orderCity}"),
                      ]
                  ),
                ],
              ),
              Divider(),
              createHeader('assigned_orders.detail.header_also_assigned'.tr()),
              _showAlsoAssigned(assignedOrder),
              Divider(),
              createHeader('assigned_orders.detail.header_orderlines'.tr()),
              _createOrderlinesTable(),
              Divider(),
              createHeader('assigned_orders.detail.header_documents'.tr()),
              _buildDocumentsTable(),
              Divider(),
              _buildButtons(context),
            ]
        )
    );
  }

  // documents
  Widget _buildDocumentsTable() {
    if(assignedOrder.order!.documents!.length == 0) {
      return buildEmptyListFeedback();
    }

    List<TableRow> rows = [];

    // header
    rows.add(TableRow(
      children: [
        Column(children: [
          createTableHeaderCell('generic.info_name'.tr())
        ]),
        Column(children: [
          createTableHeaderCell('generic.info_description'.tr())
        ]),
        Column(children: [
          createTableHeaderCell('generic.info_document'.tr())
        ]),
        Column(children: [
          createTableHeaderCell('generic.action_open'.tr())
        ])
      ],
    ));

    for (int i = 0; i < assignedOrder.order!.documents!.length; ++i) {
      OrderDocument document = assignedOrder.order!.documents![i];

      rows.add(TableRow(children: [
        Column(
            children: [
              createTableColumnCell(document.name)
            ]
        ),
        Column(
            children: [
              createTableColumnCell(document.description)
            ]
        ),
        Column(
            children: [
              createTableColumnCell(document.file!.split('/').last)
            ]
        ),
        Column(children: [
          IconButton(
            icon: Icon(Icons.view_agenda, color: Colors.red),
            onPressed: () async {
              String url = coreApi.getUrl(document.url!);
              launch(url);
            },
          )
        ]),
      ]));
    }

    return createTable(rows);
  }

  // orderlines
  Widget _createOrderlinesTable() {
    if(assignedOrder.order!.orderLines!.length == 0) {
      return buildEmptyListFeedback();
    }

    List<TableRow> rows = [];

    // header
    rows.add(TableRow(
      children: [
        Column(
            children:[
              createTableHeaderCell('orders.info_equipment'.tr())
            ]
        ),
        Column(
            children:[
              createTableHeaderCell('orders.info_location'.tr())
            ]
        ),
        Column(
            children:[
              createTableHeaderCell('orders.info_remarks'.tr())
            ]
        )
      ],

    ));

    for (int i = 0; i < assignedOrder.order!.orderLines!.length; ++i) {
      Orderline orderline = assignedOrder.order!.orderLines![i];

      rows.add(
          TableRow(
              children: [
                Column(
                    children:[
                      createTableColumnCell(orderline.product!)
                    ]
                ),
                Column(
                    children:[
                      createTableColumnCell(orderline.location!)
                    ]
                ),
                Column(
                    children:[
                      createTableColumnCell(orderline.remarks!)
                    ]
                ),
              ]
          )
      );
    }

    return createTable(rows);
  }

  Widget _buildButtons(BuildContext context) {
    // if not started, only show first startCode as a button
    if (!assignedOrder.isStarted!) {
      StartCode startCode = assignedOrder.startCodes![0];

      return Container(
        child: Column(
          children: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.blue, // background
                onPrimary: Colors.white, // foreground
              ),
              child: new Text(startCode.description!),
              onPressed: () {
                final bloc = BlocProvider.of<AssignedOrderBloc>(context);
                bloc.add(AssignedOrderEvent(status: AssignedOrderEventStatus.DO_ASYNC));
                bloc.add(AssignedOrderEvent(
                    status: AssignedOrderEventStatus.REPORT_STARTCODE,
                    code: startCode,
                    value: assignedOrder.id
                ));
              },
            ),
          ],
        ),
      );
    }

    if (assignedOrder.isStarted!) {
      // started, show 'Register time/km' and 'Finish order'
      ElevatedButton activityButton = ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.blue, // background
          onPrimary: Colors.white, // foreground
        ),
        child: new Text('assigned_orders.detail.button_register_time_km'.tr()),
        onPressed: () {
          final page = AssignedOrderActivityPage(assignedOrderPk: assignedOrder.id!);
          Navigator.push(context,
              MaterialPageRoute(
                  builder: (context) => page
              )
          );
        },
      );

      EndCode endCode = assignedOrder.endCodes![0];

      ElevatedButton finishButton = ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.blue, // background
          onPrimary: Colors.white, // foreground
        ),
        child: new Text(endCode.description!),
        onPressed: () {
          final bloc = BlocProvider.of<AssignedOrderBloc>(context);
          bloc.add(AssignedOrderEvent(status: AssignedOrderEventStatus.DO_ASYNC));
          bloc.add(AssignedOrderEvent(
              status: AssignedOrderEventStatus.REPORT_ENDCODE,
              code: endCode,
              value: assignedOrder.id
          ));
        },
      );

      // no ended yet, show a subset of the buttons
      if (!assignedOrder.isEnded!) {
        return Container(
          child: Column(
            children: <Widget>[
              activityButton,
              Divider(),
              finishButton,
            ],
          ),
        );
      }

      // ended, show all buttons
      return Container(
        child: Column(
          children: <Widget>[
            activityButton,
            Divider(),
            finishButton,
          ],
        ),
      );
    }

    return Text('This should not happen');
  }

  _showAlsoAssigned(AssignedOrder assignedOrder) {
    if (assignedOrder.assignedUserData!.length == 0) {
      return Table(children: [
        TableRow(
            children: [
              Column(children: [
                createTableColumnCell('assigned_orders.detail.info_no_one_else_assigned'.tr())
              ])
            ]
        )
      ]);
    }

    List<TableRow> users = [];

    for (int i=0; i<assignedOrder.assignedUserData!.length; i++) {
      users.add(TableRow(
          children: [
            Column(children: [
              createTableColumnCell(assignedOrder.assignedUserData![i].fullName!)
            ])
          ]
      )
      );
    }

    return Table(children: users);
  }
}
