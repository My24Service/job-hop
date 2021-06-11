import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobhop/utils/state.dart';
import 'package:jobhop/utils/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'package:jobhop/core/widgets/drawers.dart';
import 'package:jobhop/mobile/widgets/assigned_list.dart';
import 'package:jobhop/mobile/blocs/assignedorder_bloc.dart';
import 'package:jobhop/mobile/blocs/assignedorder_states.dart';


class AssignedOrderListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _AssignedOrderListPageState();
}

class _AssignedOrderListPageState extends State<AssignedOrderListPage> {
  AssignedOrderBloc bloc = AssignedOrderBloc(AssignedOrderInitialState());

  Future<String?> _getFirstName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('first_name');
  }

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
            title: Consumer<AppStateModel>(
              builder: (context, state, child) {
                return Text('assigned_orders.list.app_bar_title'.tr(
                    namedArgs: { 'firstName': state.user.firstName! }));
              },
            ),
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
