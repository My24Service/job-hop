import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:easy_localization/easy_localization.dart';

import 'package:jobhop/core/api/api.dart';
import 'package:jobhop/mobile/models/models.dart';
import 'package:jobhop/order/models/models.dart';


class MobileApi with ApiMixin {
  // default and setable for tests
  http.Client _httpClient = new http.Client();

  set httpClient(http.Client client) {
    _httpClient = client;
  }

  Future<AssignedOrders> fetchAssignedOrders() async {
    // refresh last position
    // localUtils.storeLastPosition();

    // send device token
    // await localUtils.postDeviceToken();

    final String url = getUrl('/mobile/assignedorder/list_app/');

    final response = await _httpClient.get(
      Uri.parse(url),
      headers: await getHeaders()
    );

    if (response.statusCode == 200) {
      return AssignedOrders.fromJson(json.decode(response.body));
    }

    throw Exception('assigned_orders.list.exception_fetch'.tr());
  }

  Future<AssignedOrder> fetchAssignedOrder(int assignedorderPk) async {
    final String url = getUrl('/mobile/assignedorder/$assignedorderPk/detail_device/');
    final response = await _httpClient.get(
        Uri.parse(url),
        headers: await getHeaders()
    );

    if (response.statusCode == 200) {
      return AssignedOrder.fromJson(json.decode(response.body));
    }

    throw Exception('assigned_orders.detail.exception_fetch'.tr());
  }

  Future<bool> reportStartCode(StartCode startCode, int assignedorderPk) async {
    final String url = getUrl('/mobile/assignedorder/$assignedorderPk/report_statuscode/');

    final Map body = {
      'statuscode_pk': startCode.id,
    };

    final response = await _httpClient.post(
      Uri.parse(url),
      body: json.encode(body),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      return true;
    }

    return false;
  }

  Future<bool> reportEndCode(EndCode endCode, int assignedorderPk) async {
    final String url = getUrl('/mobile/assignedorder/$assignedorderPk/report_statuscode/');

    final Map body = {
      'statuscode_pk': endCode.id,
    };

    final response = await _httpClient.post(
      Uri.parse(url),
      body: json.encode(body),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      return true;
    }

    return false;
  }

  // activity
  Future<AssignedOrderActivities> fetchAssignedOrderActivities(int assignedorderPk) async {
    final String url = getUrl('/mobile/assignedorderactivity/?assigned_order=$assignedorderPk');
    final response = await _httpClient.get(
      Uri.parse(url),
      headers: await getHeaders()
    );

    if (response.statusCode == 200) {
      return AssignedOrderActivities.fromJson(json.decode(response.body));
    }

    throw Exception('assigned_orders.activity.exception_fetch'.tr());
  }

  Future<AssignedOrderActivity?> insertAssignedOrderActivity(AssignedOrderActivity activity, int assignedorderPk) async {
    final String? url = await getUrl('/mobile/assignedorderactivity/');

    final Map body = {
      'activity_date': activity.activityDate,
      'assigned_order': assignedorderPk,
      'distance_to': activity.distanceTo,
      'distance_back': activity.distanceBack,
      'travel_to': activity.travelTo,
      'travel_back': activity.travelBack,
      'work_start': activity.workStart,
      'work_end': activity.workEnd,
    };

    final response = await _httpClient.post(
      Uri.parse(url!),
      body: json.encode(body),
      headers: await getHeaders(),
    );

    if (response.statusCode == 201) {
      return AssignedOrderActivity.fromJson(json.decode(response.body));
    }

    return null;
  }

  Future<bool> deleteAssignedOrderActivity(int activityPk) async {
    final String url = getUrl('/mobile/assignedorderactivity/$activityPk/');
    final response = await _httpClient.delete(
      Uri.parse(url),
      headers: await getHeaders()
    );

    if (response.statusCode == 204) {
      return true;
    }

    return false;
  }

  Future<Trips> fetchTrips() async {
    final String url = getUrl('/mobile/trip/');

    final response = await _httpClient.get(
        Uri.parse(url),
        headers: await getHeaders()
    );

    if (response.statusCode == 200) {
      return Trips.fromJson(json.decode(response.body));
    }

    throw Exception('assigned_orders.list.exception_fetch'.tr());
  }

  Future<bool> setAvailable(int tripPk) async {
    final String url = getUrl('/mobile/user-trip-availability/');

    final Map body = {
      'trip': tripPk,
    };

    final response = await _httpClient.post(
        Uri.parse(url),
        body: json.encode(body),
        headers: await getHeaders()
    );

    if (response.statusCode == 200) {
      return true;
    }

    throw false;

  }
}

MobileApi mobileApi = MobileApi();
