import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:jobhop/mobile/api/mobile_api.dart';
import 'package:jobhop/mobile/blocs/availability_states.dart';
import 'package:jobhop/mobile/models/models.dart';

enum TripUserAvailabilityEventStatus {
  DO_ASYNC,
  FETCH_ALL,
  DELETE,
}

class TripUserAvailabilityEvent {
  final dynamic status;
  final dynamic value;

  const TripUserAvailabilityEvent({this.status, this.value});
}

class TripUserAvailabilityBloc extends Bloc<TripUserAvailabilityEvent, TripUserAvailabilityState> {
  MobileApi localMobileApi = mobileApi;
  TripUserAvailabilityBloc(TripUserAvailabilityState initialState) : super(initialState);

  @override
  Stream<TripUserAvailabilityState> mapEventToState(event) async* {
    if (event.status == TripUserAvailabilityEventStatus.DO_ASYNC) {
      yield TripUserAvailabilityLoadingState();
    }

    if (event.status == TripUserAvailabilityEventStatus.FETCH_ALL) {
      try {
        final TripUserAvailabilities tripUserAvailabilities = await localMobileApi.fetchTripUserAvailability();
        yield TripUserAvailabilitiesLoadedState(tripUserAvailabilities: tripUserAvailabilities);
      } catch(e) {
        yield TripUserAvailabilityErrorState(message: e.toString());
      }
    }

    if (event.status == TripUserAvailabilityEventStatus.DELETE) {
      try {
        final bool result = await localMobileApi.deleteTripUserAvailability(event.value);
        yield TripUserAvailabilityDeletedState(result: result);
      } catch (e) {
        yield TripUserAvailabilityErrorState(message: e.toString());
      }
    }
  }
}
