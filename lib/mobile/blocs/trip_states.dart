import 'package:equatable/equatable.dart';
import 'package:jobhop/mobile/models/models.dart';

abstract class TripState extends Equatable {}

class TripInitialState extends TripState {
  @override
  List<Object> get props => [];
}

class TripLoadingState extends TripState {
  @override
  List<Object> get props => [];
}


class TripErrorState extends TripState {
  final String message;

  TripErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class TripsLoadedState extends TripState {
  final Trips trips;

  TripsLoadedState({required this.trips});

  @override
  List<Object> get props => [trips];
}

class TripSetAvailableState extends TripState {
  final bool result;
  final Trip trip;

  TripSetAvailableState({required this.result, required this.trip});

  @override
  List<Object> get props => [result, trip];
}
