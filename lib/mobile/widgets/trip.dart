import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:jobhop/mobile/blocs/trip_bloc.dart';
import 'package:jobhop/mobile/models/models.dart';
import 'package:jobhop/core/widgets/widgets.dart';

class TripListWidget extends StatelessWidget {
  final List<Trip> tripList;

  TripListWidget({
    required this.tripList,
  });

  @override
  Widget build(BuildContext context) {
    return _buildList(context);
  }

  Widget _buildList(BuildContext context) {
    if (tripList.length == 0) {
      return RefreshIndicator(
          child: Center(
              child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    Center(
                        child: Column(
                          children: [
                            SizedBox(height: 30),
                            Text('trips.notice_no_trips'.tr())
                          ],
                        )
                    )
                  ]
              )
          ),
          onRefresh: () => _doRefresh(context)
      );
    }

    return RefreshIndicator(
      child: ListView.builder(
          padding: EdgeInsets.all(8),
          itemCount: tripList.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
                title: _createTripTitle(tripList[index]),
                subtitle: _createTripOrders(tripList[index], context),
            );
          } // itemBuilder
      ),
      onRefresh: () => _doRefresh(context),
    );
  }

  Widget _createTripTitle(Trip trip) {
    Table tripInfo = Table(
      children: [
        TableRow(
            children: createTableRowPair(
                'trips.info_trip_date'.tr(), '${trip.tripDate}')
        ),
        TableRow(
            children: createTableRowPair(
                'trips.info_number_required'.tr(), '${trip.requiredUsers}')
        ),
        TableRow(
            children: createTableRowPair(
                'trips.info_number_still_available'.tr(), '${trip.numberStillAvailable}')
        ),
        TableRow(
            children: [
              SizedBox(height: 10),
              Text(''),
            ]
        )
      ],
    );

    return Column(
      children: [
        createHeader(
            'trips.header_trip_info'.tr(namedArgs: {'id': trip.id.toString()})),
        tripInfo,
      ],
    );
  }

  Widget _createTripOrders(Trip trip, BuildContext context) {
    List<Widget> ordersColumn = [
      createHeader('trips.header_orders'.tr())
    ];

    for (int i=0; i<trip.tripOrders.length; i++) {
      TripOrder order = trip.tripOrders[i];

      ordersColumn.add(Table(
        children: [
          TableRow(
              children: createTableRowPair(
                  'orders.info_customer'.tr(), '${order.name}'),
          ),
          TableRow(
              children: [
                SizedBox(height: 3),
                SizedBox(height: 3),
              ]
          ),
          TableRow(
              children: createTableRowPair(
                  'orders.info_address'.tr(), '${order.address}'),
          ),
          TableRow(
              children: createTableRowPair(
                  'orders.info_location'.tr(),
                  '${order.countryCode}-${order.postal} ${order.city}'),
          ),
          TableRow(
              children: [
                Divider(),
                Divider(),
              ]
          ),
        ],
      ));
    }

    if (trip.userTripIsAvailable) {
      ordersColumn.add(
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.red, // background
              onPrimary: Colors.white, // foreground
            ),
            child: new Text('trips.button_set_available'.tr()),
            onPressed: () => _showSetAvailableDialog(trip.id, context),
          )
      );
    } else {
      ordersColumn.add(
        Text(
            'trips.notice_user_has_set_available'.tr(),
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                color: Colors.red)
        )
      );
    }

    return Column(
      children: ordersColumn,
    );
  }

  _showSetAvailableDialog(int tripPk, BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
        child: Text('generic.action_cancel'.tr()),
        onPressed: () => Navigator.of(context).pop(false)
    );
    Widget setAvailableButton = TextButton(
        child: Text('trips.action_set_available'.tr()),
        onPressed: () => Navigator.of(context).pop(true)
    );

    // set up the AlertDialog
    AlertDialog dialog = AlertDialog(
      title: Text('trips.dialog_title_set_available'.tr()),
      content: Text('trips.dialog_content_set_available'.tr()),
      actions: [
        cancelButton,
        setAvailableButton,
      ],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return dialog;
      },
    ).then((dialogResult) {
      if (dialogResult == null) return;

      if (dialogResult) {
        _doSetAvailable(tripPk, context);
      }
    });
  }

  _doSetAvailable(int tripPk, BuildContext context) {
    final bloc = BlocProvider.of<TripBloc>(context);

    bloc.add(TripEvent(status: TripEventStatus.DO_ASYNC));
    bloc.add(TripEvent(
        status: TripEventStatus.SET_AVAILABLE, value: tripPk));
  }

  _doRefresh(BuildContext context) {
    final bloc = BlocProvider.of<TripBloc>(context);

    bloc.add(TripEvent(status: TripEventStatus.DO_ASYNC));
    bloc.add(TripEvent(
        status: TripEventStatus.FETCH_ALL
    ));

    return Future.delayed(Duration(milliseconds: 100));
  }
}
