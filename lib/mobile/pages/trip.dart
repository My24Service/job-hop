import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:jobhop/core/widgets/widgets.dart';
import 'package:jobhop/core/widgets/drawers.dart';
import 'package:jobhop/mobile/models/models.dart';
import 'package:jobhop/mobile/widgets/trip.dart';
import 'package:jobhop/mobile/blocs/trip_bloc.dart';
import 'package:jobhop/mobile/blocs/trip_states.dart';
import 'package:jobhop/utils/generic.dart';

GetIt getIt = GetIt.instance;

class TripListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _TripListPageState();
}

class _TripListPageState extends State<TripListPage> {
  TripBloc bloc = TripBloc(TripInitialState());

  _showCreateCalendarEntriesDialog(Trip trip, BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
        child: Text('generic.action_cancel'.tr()),
        onPressed: () => Navigator.of(context).pop(false)
    );
    Widget setAvailableButton = TextButton(
        child: Text('trips.button_add_calendar_entries'.tr()),
        onPressed: () => Navigator.of(context).pop(true)
    );

    // set up the AlertDialog
    AlertDialog dialog = AlertDialog(
      title: Text('trips.dialog_title_create_calendar_entries'.tr()),
      content: Text(
          'trips.dialog_content_create_calendar_entries'.tr(
              namedArgs: {'numOrders': '${trip.tripOrders.length}'})),
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
        for (int i=0; i<trip.tripOrders.length; i++) {
          createCalendarEvent(trip.tripOrders[i]);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    _initialBlocCall() {
      final bloc = TripBloc(TripInitialState());

      bloc.add(TripEvent(status: TripEventStatus.DO_ASYNC));
      bloc.add(TripEvent(
          status: TripEventStatus.FETCH_ALL
      ));

      return bloc;
    }

    return BlocProvider(
        create: (BuildContext context) => _initialBlocCall(),
        child: Scaffold(
            drawer: createDrawer(context),
            appBar: AppBar(
                title: Text('trips.app_bar_title'.tr())
            ),
            body: BlocListener<TripBloc, TripState>(
                listener: (context, state) {
                  if (state is TripSetAvailableState) {
                    if (state.result == true) {
                      bloc = BlocProvider.of<TripBloc>(context);

                      createSnackBar(
                          context,
                          'trips.snackbar_set_available'.tr());

                      // ask if we should create calendar entries
                      _showCreateCalendarEntriesDialog(state.trip, context);

                      bloc.add(TripEvent(
                          status: TripEventStatus.DO_ASYNC));
                      bloc.add(TripEvent(
                          status: TripEventStatus.FETCH_ALL));
                    } else {
                      displayDialog(context,
                          'generic.error_dialog_title'.tr(),
                          'trips.error_set_available_dialog_content'.tr());
                    }
                  }
                },
                child: BlocBuilder<TripBloc, TripState>(
                    builder: (context, state) {
                      if (state is TripInitialState) {
                        return loadingNotice();
                      }

                      if (state is TripLoadingState) {
                        return loadingNotice();
                      }

                      if (state is TripErrorState) {
                        return errorNoticeWithReload(
                            state.message,
                            bloc,
                            TripEvent(
                                status: TripEventStatus.FETCH_ALL)
                        );
                      }

                      if (state is TripsLoadedState) {
                        return TripListWidget(
                            tripList: state.trips.results
                        );
                      }

                      return loadingNotice();
                    }
                )
            )
        )
    );
  }
}
