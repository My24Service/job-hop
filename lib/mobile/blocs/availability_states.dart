import 'package:equatable/equatable.dart';
import 'package:jobhop/mobile/models/models.dart';

abstract class TripUserAvailabilityState extends Equatable {}

class TripUserAvailabilityInitialState extends TripUserAvailabilityState {
  @override
  List<Object> get props => [];
}

class TripUserAvailabilityLoadingState extends TripUserAvailabilityState {
  @override
  List<Object> get props => [];
}


class TripUserAvailabilityErrorState extends TripUserAvailabilityState {
  final String message;

  TripUserAvailabilityErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class TripUserAvailabilitiesLoadedState extends TripUserAvailabilityState {
  final TripUserAvailabilities tripUserAvailabilities;

  TripUserAvailabilitiesLoadedState({required this.tripUserAvailabilities});

  @override
  List<Object> get props => [tripUserAvailabilities];
}

class TripUserAvailabilityDeletedState extends TripUserAvailabilityState {
  final bool result;

  TripUserAvailabilityDeletedState({required this.result});

  @override
  List<Object> get props => [result];
}
