import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:jobhop/mobile/blocs/availability_bloc.dart';
import 'package:jobhop/mobile/models/models.dart';
import 'package:jobhop/core/widgets/widgets.dart';

class AvailabilityListWidget extends StatelessWidget {
  final List<TripUserAvailability> availabilities;

  AvailabilityListWidget({
    required this.availabilities,
  });

  @override
  Widget build(BuildContext context) {
    return _buildList(context);
  }

  Widget _buildList(BuildContext context) {
    if (availabilities.length == 0) {
      return RefreshIndicator(
          child: Center(
              child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          children: [
                            SizedBox(height: 30),
                            Text('availability.notice_no_availability'.tr())
                          ],
                        )
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
          itemCount: availabilities.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: _createTripAvailabilityTitle(availabilities[index]),
              subtitle: _createTripAvailabilitySubTitle(availabilities[index], context),
            );
          } // itemBuilder
      ),
      onRefresh: () => _doRefresh(context),
    );
  }

  Widget _createTripAvailabilityTitle(TripUserAvailability availability) {
    Table tripInfo = Table(
      children: [
        TableRow(
            children: createTableRowPair(
                'trips.info_trip_date'.tr(), '${availability.tripDate}')
        ),
        TableRow(
            children: createTableRowPair(
                'trips.info_description'.tr(), '${availability.description}')
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
        tripInfo,
      ],
    );
  }

  Widget _createTripAvailabilitySubTitle(TripUserAvailability availability, BuildContext context) {
    Table table = Table(
        children: [
          TableRow(
            children: createTableRowPair(
                'availability.info_accepted'.tr(),
                availability.isAccepted ? 'availability.info_yes'.tr() : 'availability.info_no'.tr()
            ),
          ),
          TableRow(
            children: createTableRowPair(
                'availability.info_created'.tr(), '${availability.created}'),
          ),
          TableRow(
            children: createTableRowPair(
                'availability.info_modified'.tr(), '${availability.modified}'),
          ),
        ]
    );

    if (availability.isAccepted) {
      return Column(
        children: [
          table
        ],
      );
    }

    // not yet accepted, the user can still delete it
    return Column(
      children: [
        table,
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red, // background
            foregroundColor: Colors.white, // foreground
          ),
          child: new Text('availability.button_delete'.tr()),
          onPressed: () => _showDeleteDialog(context, availability.id),
        )
      ],
    );
  }

  _showDeleteDialog(BuildContext context, int availabilityPk) {
    showDeleteDialogWrapper(
        'availability.delete_dialog_title'.tr(),
        'availability.delete_dialog_content'.tr(),
        context, () => _doDelete(context, availabilityPk));
  }

  _doDelete(BuildContext context, int availabilityPk) async {
    final bloc = BlocProvider.of<TripUserAvailabilityBloc>(context);

    bloc.add(TripUserAvailabilityEvent(status: TripUserAvailabilityEventStatus.DO_ASYNC));
    bloc.add(TripUserAvailabilityEvent(
        status: TripUserAvailabilityEventStatus.DELETE, value: availabilityPk));
  }

  _doRefresh(BuildContext context) {
    final bloc = BlocProvider.of<TripUserAvailabilityBloc>(context);

    bloc.add(TripUserAvailabilityEvent(status: TripUserAvailabilityEventStatus.DO_ASYNC));
    bloc.add(TripUserAvailabilityEvent(
        status: TripUserAvailabilityEventStatus.FETCH_ALL
    ));

    return Future.delayed(Duration(milliseconds: 100));
  }
}
