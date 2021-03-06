import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:jobhop/mobile/blocs/assignedorder_bloc.dart';
import 'package:jobhop/mobile/models/models.dart';
import 'package:jobhop/mobile/pages/assigned.dart';
import 'package:jobhop/core/widgets/widgets.dart';

class AssignedListWidget extends StatelessWidget {
  final List<AssignedOrder> orderList;

  AssignedListWidget({
    required this.orderList,
  });

  @override
  Widget build(BuildContext context) {
    return _buildList(context);
  }

  Widget _buildList(BuildContext context) {
    if (orderList.length == 0) {
      return RefreshIndicator(
          child: Center(
              child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    Center(
                        child: Column(
                          children: [
                            SizedBox(height: 30),
                            Text('assigned_orders.list.notice_no_order'.tr())
                          ],
                        )
                    )
                  ]
              )
          ),
          onRefresh: () => _doRefresh(context)
      );
    }

    return RefreshIndicator(
      child: ListView.builder(
          padding: EdgeInsets.all(8),
          itemCount: orderList.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
                title: createOrderListHeader(orderList[index].order!),
                subtitle: createOrderListSubtitle(orderList[index].order!),
                onTap: () {
                  // navigate to next page
                  final page = AssignedOrderPage(assignedOrderPk: orderList[index].id!);

                  Navigator.push(context,
                      new MaterialPageRoute(builder: (context) => page
                      )
                  );
                } // onTab
            );
          } // itemBuilder
      ),
      onRefresh: () => _doRefresh(context),
    );
  }

  _doRefresh(BuildContext context) {
    final bloc = BlocProvider.of<AssignedOrderBloc>(context);

    bloc.add(AssignedOrderEvent(status: AssignedOrderEventStatus.DO_ASYNC));
    bloc.add(AssignedOrderEvent(
        status: AssignedOrderEventStatus.FETCH_ALL
    ));

    return Future.delayed(Duration(milliseconds: 100));
  }
}
