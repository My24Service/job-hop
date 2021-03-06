import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:jobhop/mobile/blocs/activity_bloc.dart';
import 'package:jobhop/mobile/blocs/activity_states.dart';
import 'package:jobhop/mobile/widgets/activity.dart';
import 'package:jobhop/core/widgets/widgets.dart';


class AssignedOrderActivityPage extends StatefulWidget {
  final int assignedOrderPk;

  AssignedOrderActivityPage({
    required this.assignedOrderPk
  });

  @override
  State<StatefulWidget> createState() => new _AssignedOrderActivityPageState();
}

class _AssignedOrderActivityPageState extends State<AssignedOrderActivityPage> {
  ActivityBloc bloc = ActivityBloc(ActivityInitialState());

  @override
  Widget build(BuildContext context) {
    _initalBlocCall() {
      final bloc = ActivityBloc(ActivityInitialState());
      bloc.add(ActivityEvent(status: ActivityEventStatus.DO_ASYNC));
      bloc.add(ActivityEvent(
          status: ActivityEventStatus.FETCH_ALL,
          value: widget.assignedOrderPk
      ));

      return bloc;
    }

    return BlocProvider(
        create: (BuildContext context) => _initalBlocCall(),
        child: Scaffold(
            appBar: AppBar(
              title: new Text('assigned_orders.activity.app_bar_title'.tr()),
            ),
            body: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: BlocListener<ActivityBloc, AssignedOrderActivityState>(
                    listener: (context, state) async {
                      if (state is ActivityInsertedState) {
                        createSnackBar(context, 'assigned_orders.activity.snackbar_added'.tr());

                        bloc.add(ActivityEvent(
                            status: ActivityEventStatus.FETCH_ALL,
                            value: widget.assignedOrderPk
                        ));
                      }
                      if (state is ActivityDeletedState) {
                        if (state.result == true) {
                          createSnackBar(context, 'assigned_orders.activity.snackbar_deleted'.tr());

                          bloc.add(ActivityEvent(
                              status: ActivityEventStatus.FETCH_ALL,
                              value: widget.assignedOrderPk
                          ));
                        } else {
                          displayDialog(context,
                              'generic.error_dialog_title'.tr(),
                              'assigned_orders.activity.error_deleting_dialog_content'.tr()
                          );
                        }
                      }
                    },
                    child: BlocBuilder<ActivityBloc, AssignedOrderActivityState>(
                        builder: (context, state) {
                          bloc = BlocProvider.of<ActivityBloc>(context);

                          if (state is ActivityInitialState) {
                            return loadingNotice();
                          }

                          if (state is ActivityLoadingState) {
                            return loadingNotice();
                          }

                          if (state is ActivityErrorState) {
                            return errorNotice(state.message);
                          }

                          if (state is ActivitiesLoadedState) {
                            return ActivityWidget(
                              activities: state.activities,
                              assignedOrderPk: widget.assignedOrderPk,
                            );
                          }

                          return loadingNotice();
                        }
                    )
                )
            )
        )
    );
  }
}
