import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:jobhop/core/widgets/widgets.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'package:jobhop/mobile/models/models.dart';
import 'package:jobhop/mobile/blocs/activity_bloc.dart';
import 'package:jobhop/mobile/api/mobile_api.dart';
import 'package:jobhop/utils/generic.dart';

class ActivityWidget extends StatefulWidget {
  final AssignedOrderActivities activities;
  final int assignedOrderPk;

  ActivityWidget({required this.activities, required this.assignedOrderPk});

  @override
  State<StatefulWidget> createState() => new _ActivityWidgetState(
      activities: activities, assignedOrderPk: assignedOrderPk);
}

class _ActivityWidgetState extends State<ActivityWidget> {
  final AssignedOrderActivities activities;
  final int assignedOrderPk;

  _ActivityWidgetState({
    required this.activities,
    required this.assignedOrderPk,
  }) : super();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var _startWorkHourController = TextEditingController();
  var _endWorkHourController = TextEditingController();
  var _travelToController = TextEditingController();
  var _travelBackController = TextEditingController();

  bool _isTrip = true;

  String _workStartMin = '00';
  String _workEndMin = '00';
  String _travelToMin = '00';
  String _travelBackMin = '00';

  final List<String> minutes = ['00', '15', '30', '45'];

  DateTime _activityDate = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  bool _inAsyncCall = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
        child: _showMainView(context), inAsyncCall: _inAsyncCall);
  }

  Widget _showMainView(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Form(
            key: _formKey,
            child: Container(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                    // new line
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        child: _buildForm(context),
                      ),
                      Divider(),
                      createHeader(
                          'assigned_orders.activity.info_header_table'.tr()),
                      _buildActivityTable(context),
                    ])))));
  }

  _doDelete(BuildContext context, AssignedOrderActivity activity) async {
    final bloc = BlocProvider.of<ActivityBloc>(context);

    bloc.add(ActivityEvent(status: ActivityEventStatus.DO_ASYNC));
    bloc.add(
        ActivityEvent(status: ActivityEventStatus.DELETE, value: activity.id));
  }

  _showDeleteDialog(AssignedOrderActivity activity, BuildContext context) {
    showDeleteDialogWrapper(
        'assigned_orders.activity.delete_dialog_title'.tr(),
        'assigned_orders.activity.delete_dialog_content'.tr(),
        context,
        () => _doDelete(context, activity));
  }

  Widget _buildActivityTable(BuildContext context) {
    if (activities.results.length == 0) {
      return buildEmptyListFeedback();
    }

    List<TableRow> rows = [];

    // header
    rows.add(TableRow(
      children: [
        Column(children: [
          createTableHeaderCell(
              'assigned_orders.activity.info_work_start_end'.tr())
        ]),
        Column(children: [
          createTableHeaderCell(
              'assigned_orders.activity.info_travel_to_back'.tr())
        ]),
        Column(children: [
          createTableHeaderCell(
              'assigned_orders.activity.info_distance_fixed_rate_amount'.tr())
        ]),
        Column(children: [createTableHeaderCell('generic.action_delete'.tr())])
      ],
    ));

    // products
    for (int i = 0; i < activities.results.length; ++i) {
      AssignedOrderActivity activity = activities.results[i];

      rows.add(TableRow(children: [
        Column(children: [
          createTableColumnCell("${activity.workStart}/${activity.workEnd}")
        ]),
        Column(children: [
          createTableColumnCell("${activity.travelTo}/${activity.travelBack}")
        ]),
        Column(children: [
          createTableColumnCell(
              activity.distanceFixedRateAmount! > 0 ? "assigned_orders.activity.info_yes".tr() : "assigned_orders.activity.info_no".tr())
        ]),
        Column(children: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              _showDeleteDialog(activity, context);
            },
          )
        ]),
      ]));
    }

    return createTable(rows);
  }

  _selectActivityDate(BuildContext context) async {
    DateTime now = DateTime.now();
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(now.year - 1),
        lastDate: DateTime(now.year + 2)
    );

    setState(() {
      _activityDate = pickedDate!;
    });
  }

  _buildWorkStartMinutes() {
    return DropdownButton<String>(
      value: _workStartMin,
      items: minutes.map((String value) {
        return new DropdownMenuItem<String>(
          child: new Text(value),
          value: value,
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          _workStartMin = newValue!;
        });
      },
    );
  }

  _buildWorkEndMinutes() {
    return DropdownButton<String>(
      value: _workEndMin,
      items: minutes.map((String value) {
        return new DropdownMenuItem<String>(
          child: new Text(value),
          value: value,
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          _workEndMin = newValue!;
        });
      },
    );
  }

  _buildTravelToMinutes() {
    return DropdownButton<String>(
      value: _travelToMin,
      items: minutes.map((String value) {
        return new DropdownMenuItem<String>(
          child: new Text(value),
          value: value,
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          _travelToMin = newValue!;
        });
      },
    );
  }

  _buildTravelBackMinutes() {
    return DropdownButton<String>(
      value: _travelBackMin,
      items: minutes.map((String value) {
        return new DropdownMenuItem<String>(
          child: new Text(value),
          value: value,
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          _travelBackMin = newValue!;
        });
      },
    );
  }

  Widget _buildForm(BuildContext context) {
    final double leftWidth = 100;
    final double rightWidth = 50;

    return Column(
      children: <Widget>[
        SizedBox(
          height: 20.0,
        ),
        createHeader('assigned_orders.activity.header_new_activity'.tr()),
        SizedBox(
          height: 20.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Text('assigned_orders.activity.label_start_work'.tr()),
                Row(
                  children: [
                    Container(
                      width: leftWidth,
                      child: TextFormField(
                        controller: _startWorkHourController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'assigned_orders.activity.validator_start_work_hour'
                                .tr();
                          }
                          return null;
                        },
                        decoration: new InputDecoration(
                            labelText:
                                'assigned_orders.activity.info_hours'.tr()),
                      ),
                    ),
                    Container(
                        width: rightWidth, child: _buildWorkStartMinutes())
                  ],
                )
              ],
            )
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Text('assigned_orders.activity.label_end_work'.tr()),
                Row(
                  children: [
                    Container(
                      width: leftWidth,
                      child: TextFormField(
                          controller: _endWorkHourController,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'assigned_orders.activity.validator_end_work_hour'
                                  .tr();
                            }
                            return null;
                          },
                          decoration: new InputDecoration(
                              labelText:
                                  'assigned_orders.activity.info_hours'.tr())),
                    ),
                    Container(width: rightWidth, child: _buildWorkEndMinutes())
                  ],
                )
              ],
            )
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Text('assigned_orders.activity.label_travel_to'.tr()),
                Row(
                  children: [
                    Container(
                      width: leftWidth,
                      child: TextFormField(
                          controller: _travelToController,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'assigned_orders.activity.validator_travel_to_hours'
                                  .tr();
                            }
                            return null;
                          },
                          decoration: new InputDecoration(
                              labelText:
                                  'assigned_orders.activity.info_hours'.tr())),
                    ),
                    Container(width: rightWidth, child: _buildTravelToMinutes())
                  ],
                )
              ],
            )
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Text('assigned_orders.activity.label_travel_back'.tr()),
                Row(
                  children: [
                    Container(
                      width: leftWidth,
                      child: TextFormField(
                          controller: _travelBackController,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'assigned_orders.activity.validator_travel_back_hours'
                                  .tr();
                            }
                            return null;
                          },
                          decoration: new InputDecoration(
                              labelText:
                                  'assigned_orders.activity.info_hours'.tr())),
                    ),
                    Container(
                        width: rightWidth, child: _buildTravelBackMinutes())
                  ],
                )
              ],
            )
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
        Text('assigned_orders.activity.label_trip'.tr()),
        Container(
          width: 150,
          child: Checkbox(
            value: _isTrip,
            onChanged: (bool? value) {
              setState(() {
                _isTrip = value!;
              });
            },
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Text('assigned_orders.activity.label_activity_date'.tr()),
        Container(
          width: 150,
          child: createBlueElevatedButton(
              "${_activityDate.toLocal()}".split(' ')[0],
              () => _selectActivityDate(context),
              primaryColor: Colors.white,
              onPrimary: Colors.black),
        ),
        SizedBox(
          height: 20.0,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.blue, // background
            onPrimary: Colors.white, // foreground
          ),
          child: Text('assigned_orders.activity.button_add_activity'.tr()),
          onPressed: () async {
            if (this._formKey.currentState!.validate()) {
              this._formKey.currentState!.save();

              // only continue if something is set
              if (_startWorkHourController.text == '0' &&
                  _workStartMin == '00' &&
                  _endWorkHourController.text == '0' &&
                  _workEndMin == '00' &&
                  _travelToController.text == '0' &&
                  _travelToMin == '00' &&
                  _travelBackController.text == '0' &&
                  _travelBackMin == '00') {
                FocusScope.of(context).unfocus();
                return;
              }

              AssignedOrderActivity activity = AssignedOrderActivity(
                activityDate: formatDate(_activityDate),
                workStart:
                    '${_startWorkHourController.text}:$_workStartMin:00',
                workEnd: '${_endWorkHourController.text}:$_workEndMin:00',
                travelTo: '${_travelToController.text}:$_travelToMin:00',
                travelBack: '${_travelBackController.text}:$_travelBackMin:00',
                distanceFixedRateAmount: _isTrip ? 1 : 0,
              );

              setState(() {
                _inAsyncCall = true;
              });

              AssignedOrderActivity? newActivity = await mobileApi
                  .insertAssignedOrderActivity(activity, assignedOrderPk);

              setState(() {
                _inAsyncCall = false;
              });

              if (newActivity == null) {
                displayDialog(context, 'generic.error_dialog_title'.tr(),
                    'assigned_orders.activity.error_dialog_content'.tr());
                return;
              }

              final bloc = BlocProvider.of<ActivityBloc>(context);
              bloc.add(ActivityEvent(status: ActivityEventStatus.INSERTED));
            }
          },
        ),
      ],
    );
  }
}
