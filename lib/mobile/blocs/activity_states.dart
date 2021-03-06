import 'package:equatable/equatable.dart';
import 'package:jobhop/mobile/models/models.dart';

abstract class AssignedOrderActivityState extends Equatable {}

class ActivityInitialState extends AssignedOrderActivityState {
  @override
  List<Object> get props => [];
}

class ActivityLoadingState extends AssignedOrderActivityState {
  @override
  List<Object> get props => [];
}

class ActivityInsertedState extends AssignedOrderActivityState {
  @override
  List<Object> get props => [];
}


class ActivityErrorState extends AssignedOrderActivityState {
  final String message;

  ActivityErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class ActivitiesLoadedState extends AssignedOrderActivityState {
  final AssignedOrderActivities activities;

  ActivitiesLoadedState({required this.activities});

  @override
  List<Object> get props => [activities];
}

class ActivityLoadedState extends AssignedOrderActivityState {
  final AssignedOrderActivity activity;

  ActivityLoadedState({required this.activity});

  @override
  List<Object> get props => [activity];
}

class ActivityDeletedState extends AssignedOrderActivityState {
  final bool result;

  ActivityDeletedState({required this.result});

  @override
  List<Object> get props => [result];
}
