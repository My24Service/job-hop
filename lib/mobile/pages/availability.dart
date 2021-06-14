import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:jobhop/core/widgets/widgets.dart';
import 'package:jobhop/core/widgets/drawers.dart';
import 'package:jobhop/mobile/widgets/availability.dart';
import 'package:jobhop/mobile/blocs/availability_bloc.dart';
import 'package:jobhop/mobile/blocs/availability_states.dart';

GetIt getIt = GetIt.instance;

class AvailabilityListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _AvailabilityListPageState();
}
// TripUserAvailabilityBloc
class _AvailabilityListPageState extends State<AvailabilityListPage> {
  TripUserAvailabilityBloc bloc = TripUserAvailabilityBloc(
      TripUserAvailabilityInitialState());

  @override
  Widget build(BuildContext context) {

    _initialBlocCall() {
      final bloc = TripUserAvailabilityBloc(TripUserAvailabilityInitialState());

      bloc.add(TripUserAvailabilityEvent(
          status: TripUserAvailabilityEventStatus.DO_ASYNC));
      bloc.add(TripUserAvailabilityEvent(
          status: TripUserAvailabilityEventStatus.FETCH_ALL
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
            body: BlocListener<TripUserAvailabilityBloc, TripUserAvailabilityState>(
                listener: (context, state) {
                  if (state is TripUserAvailabilityDeletedState) {
                    if (state.result == true) {
                      createSnackBar(
                          context,
                          'trips.snackbar_set_available'.tr());

                      bloc.add(TripUserAvailabilityEvent(
                          status: TripUserAvailabilityEventStatus.DO_ASYNC));
                      bloc.add(TripUserAvailabilityEvent(
                          status: TripUserAvailabilityEventStatus.FETCH_ALL));
                    } else {
                      displayDialog(context,
                          'generic.error_dialog_title'.tr(),
                          'trips.error_set_available_dialog_content'.tr());
                    }
                  }
                },
                child: BlocBuilder<TripUserAvailabilityBloc, TripUserAvailabilityState>(
                    builder: (context, state) {
                      if (state is TripUserAvailabilityInitialState) {
                        return loadingNotice();
                      }

                      if (state is TripUserAvailabilityLoadingState) {
                        return loadingNotice();
                      }

                      if (state is TripUserAvailabilityErrorState) {
                        return errorNoticeWithReload(
                            state.message,
                            bloc,
                            TripUserAvailabilityEvent(
                                status: TripUserAvailabilityEventStatus.FETCH_ALL)
                        );
                      }

                      if (state is TripUserAvailabilitiesLoadedState) {
                        return AvailabilityListWidget(
                            availabilities: state.tripUserAvailabilities.results
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
