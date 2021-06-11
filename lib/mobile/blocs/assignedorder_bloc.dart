import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:jobhop/mobile/api/mobile_api.dart';
import 'package:jobhop/mobile/blocs/assignedorder_states.dart';
import 'package:jobhop/mobile/models/models.dart';

enum AssignedOrderEventStatus {
  DO_ASYNC,
  FETCH_ALL,
  FETCH_DETAIL,
  REPORT_STARTCODE,
  REPORT_ENDCODE,
}

class AssignedOrderEvent {
  final dynamic status;
  final dynamic value;
  final dynamic code;

  const AssignedOrderEvent({this.status, this.value, this.code});
}

class AssignedOrderBloc extends Bloc<AssignedOrderEvent, AssignedOrderState> {
  MobileApi localMobileApi = mobileApi;
  AssignedOrderBloc(AssignedOrderState initialState) : super(initialState);

  @override
  Stream<AssignedOrderState> mapEventToState(event) async* {
    if (event.status == AssignedOrderEventStatus.DO_ASYNC) {
      yield AssignedOrderLoadingState();
    }

    if (event.status == AssignedOrderEventStatus.FETCH_ALL) {
      try {
        final AssignedOrders assignedOrders = await localMobileApi
            .fetchAssignedOrders();
        yield AssignedOrdersLoadedState(assignedOrders: assignedOrders);
      } catch (e) {
        yield AssignedOrderErrorState(message: e.toString());
      }
    }

    if (event.status == AssignedOrderEventStatus.FETCH_DETAIL) {
      try {
        final AssignedOrder assignedOrder = await localMobileApi
            .fetchAssignedOrder(event.value);
        yield AssignedOrderLoadedState(assignedOrder: assignedOrder);
      } catch (e) {
        yield AssignedOrderErrorState(message: e.toString());
      }
    }

    if (event.status == AssignedOrderEventStatus.REPORT_STARTCODE) {
      try {
        final bool result = await localMobileApi.reportStartCode(
            event.code, event.value);
        yield AssignedOrderReportStartCodeState(result: result);
      } catch (e) {
        yield AssignedOrderErrorState(message: e.toString());
      }
    }

    if (event.status == AssignedOrderEventStatus.REPORT_ENDCODE) {
      try {
        final bool result = await localMobileApi.reportEndCode(
            event.code, event.value);
        yield AssignedOrderReportEndCodeState(result: result);
      } catch (e) {
        yield AssignedOrderErrorState(message: e.toString());
      }
    }
  }
}
