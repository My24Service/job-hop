import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:jobhop/utils/state.dart';
import 'package:jobhop/core/widgets/widgets.dart';
import 'package:jobhop/core/widgets/drawers.dart';
import 'package:jobhop/mobile/widgets/trip.dart';
import 'package:jobhop/mobile/blocs/trip_bloc.dart';
import 'package:jobhop/mobile/blocs/trip_states.dart';

GetIt getIt = GetIt.instance;

class TripListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _TripListPageState();
}

class _TripListPageState extends State<TripListPage> {
  TripBloc bloc = TripBloc(TripInitialState());

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
