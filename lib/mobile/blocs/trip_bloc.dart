import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:jobhop/mobile/api/mobile_api.dart';
import 'package:jobhop/mobile/blocs/trip_states.dart';
import 'package:jobhop/mobile/models/models.dart';

enum TripEventStatus {
  DO_ASYNC,
  FETCH_ALL,
  SET_AVAILABLE,
}

class TripEvent {
  final dynamic status;
  final dynamic value;

  const TripEvent({this.status, this.value});
}

class TripBloc extends Bloc<TripEvent, TripState> {
  MobileApi localMobileApi = mobileApi;
  TripBloc(TripState initialState) : super(initialState);

  @override
  Stream<TripState> mapEventToState(event) async* {
    if (event.status == TripEventStatus.DO_ASYNC) {
      yield TripLoadingState();
    }

    if (event.status == TripEventStatus.FETCH_ALL) {
      try {
        final Trips trips = await localMobileApi.fetchTrips();
        yield TripsLoadedState(trips: trips);
      } catch(e) {
        yield TripErrorState(message: e.toString());
      }
    }

    if (event.status == TripEventStatus.SET_AVAILABLE) {
      try {
        final bool result = await localMobileApi.setAvailable(event.value);
        final Trip trip = await localMobileApi.fetchTripDetail(event.value);
        yield TripSetAvailableState(result: result, trip: trip);
      } catch (e) {
        yield TripErrorState(message: e.toString());
      }
    }
  }
}
