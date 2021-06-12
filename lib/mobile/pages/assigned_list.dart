import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:jobhop/utils/state.dart';
import 'package:jobhop/utils/widgets.dart';
import 'package:jobhop/core/widgets/drawers.dart';
import 'package:jobhop/mobile/widgets/assigned_list.dart';
import 'package:jobhop/mobile/blocs/assignedorder_bloc.dart';
import 'package:jobhop/mobile/blocs/assignedorder_states.dart';

GetIt getIt = GetIt.instance;

class AssignedOrderListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _AssignedOrderListPageState();
}

class _AssignedOrderListPageState extends State<AssignedOrderListPage> {
  AssignedOrderBloc bloc = AssignedOrderBloc(AssignedOrderInitialState());
  String _firstName = getIt<AppModel>().user.firstName ?? 'guest';

  @override
  Widget build(BuildContext context) {

    _initalBlocCall() {
      final bloc = AssignedOrderBloc(AssignedOrderInitialState());

      bloc.add(AssignedOrderEvent(status: AssignedOrderEventStatus.DO_ASYNC));
      bloc.add(AssignedOrderEvent(
          status: AssignedOrderEventStatus.FETCH_ALL
      ));

      return bloc;
    }

    return BlocProvider(
        create: (BuildContext context) => _initalBlocCall(),
        child: Scaffold(
          drawer: createDrawer(context),
          appBar: AppBar(
            title: Text('assigned_orders.list.app_bar_title'.tr(
                    namedArgs: { 'firstName': _firstName }))
          ),
          body: BlocListener<AssignedOrderBloc, AssignedOrderState>(
              listener: (context, state) {
              },
              child: BlocBuilder<AssignedOrderBloc, AssignedOrderState>(
                  builder: (context, state) {
                    if (state is AssignedOrderInitialState) {
                      return loadingNotice();
                    }

                    if (state is AssignedOrderLoadingState) {
                      return loadingNotice();
                    }

                    if (state is AssignedOrderErrorState) {
                      return errorNoticeWithReload(
                          state.message,
                          bloc,
                          AssignedOrderEvent(
                              status: AssignedOrderEventStatus.FETCH_ALL)
                      );
                    }

                    if (state is AssignedOrdersLoadedState) {
                      return AssignedListWidget(
                        orderList: state.assignedOrders.results
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
