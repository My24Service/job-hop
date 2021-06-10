import 'package:jobhop/order/models/models.dart';
import 'package:jobhop/customer/models/models.dart';

class AssignedUserdata {
  final String fullName;
  final String mobile;

  AssignedUserdata({
    this.fullName,
    this.mobile,
  });

  factory AssignedUserdata.fromJson(Map<String, dynamic> parsedJson) {
    return AssignedUserdata(
        fullName: parsedJson['full_name'],
        mobile:  parsedJson['mobile']
    );
  }
}

class AssignedOrder {
  final int id;
  final int engineer;
  final int studentUser;
  final Order order;
  bool isStarted;
  final bool isEnded;
  final Customer customer;
  final List<StartCode> startCodes;
  final List<EndCode> endCodes;
  final List<AssignedUserdata> assignedUserData;

  AssignedOrder({
    this.id,
    this.engineer,
    this.studentUser,
    this.order,
    this.isStarted,
    this.isEnded,
    this.customer,
    this.startCodes,
    this.endCodes,
    this.assignedUserData,
  });

  factory AssignedOrder.fromJson(Map<String, dynamic> parsedJson) {
    List<StartCode> startCodes = [];
    var parsedStartCodesList = parsedJson['start_codes'] as List;
    if (parsedStartCodesList != null) {
      startCodes = parsedStartCodesList.map((i) => StartCode.fromJson(i)).toList();
    }

    List<EndCode> endCodes = [];
    var parsedEndCodesList = parsedJson['end_codes'] as List;
    if (parsedEndCodesList != null) {
      endCodes = parsedEndCodesList.map((i) => EndCode.fromJson(i)).toList();
    }

    Customer customer;
    if (parsedJson['customer'] != null) {
      customer = Customer.fromJson(parsedJson['customer']);
    }

    List<AssignedUserdata> assignedUsers = [];
    var parsedUserData = parsedJson['assigned_userdata'] as List;
    if (parsedUserData != null) {
      assignedUsers = parsedUserData.map((i) => AssignedUserdata.fromJson(i)).toList();
    }

    return AssignedOrder(
      id: parsedJson['id'],
      order: Order.fromJson(parsedJson['order']),
      engineer: parsedJson['engineer'],
      studentUser: parsedJson['student_user'],
      isStarted: parsedJson['is_started'],
      isEnded: parsedJson['is_ended'],
      customer: customer,
      startCodes: startCodes,
      endCodes: endCodes,
      assignedUserData: assignedUsers,
    );
  }
}

class AssignedOrders {
  final int count;
  final String next;
  final String previous;
  final List<AssignedOrder> results;

  AssignedOrders({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  factory AssignedOrders.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['results'] as List;
    List<AssignedOrder> results = list.map((i) => AssignedOrder.fromJson(i)).toList();

    return AssignedOrders(
        count: parsedJson['count'],
        next: parsedJson['next'],
        previous: parsedJson['previous'],
        results: results
    );
  }
}

class AssignedOrderActivity  {
  final int id;
  final String activityDate;
  final int assignedOrderId;
  final String workStart;
  final String workEnd;
  final String travelTo;
  final String travelBack;
  final int odoReadingToStart;
  final int odoReadingToEnd;
  final int odoReadingBackStart;
  final int odoReadingBackEnd;
  final int distanceTo;
  final int distanceBack;
  final String fullName;

  AssignedOrderActivity({
    this.id,
    this.activityDate,
    this.assignedOrderId,
    this.workStart,
    this.workEnd,
    this.travelTo,
    this.travelBack,
    this.odoReadingToStart,
    this.odoReadingToEnd,
    this.odoReadingBackStart,
    this.odoReadingBackEnd,
    this.distanceTo,
    this.distanceBack,
    this.fullName,
  });

  factory AssignedOrderActivity.fromJson(Map<String, dynamic> parsedJson) {
    return AssignedOrderActivity(
      id: parsedJson['id'],
      activityDate: parsedJson['activity_date'],
      workStart: parsedJson['work_start'],
      workEnd: parsedJson['work_end'],
      travelTo: parsedJson['travel_to'],
      travelBack: parsedJson['travel_back'],
      odoReadingToStart: parsedJson['odo_reading_to_start'],
      odoReadingToEnd: parsedJson['odo_reading_to_end'],
      odoReadingBackStart: parsedJson['odo_reading_back_start'],
      odoReadingBackEnd: parsedJson['odo_reading_back_end'],
      distanceTo: parsedJson['distance_to'],
      distanceBack: parsedJson['distance_back'],
      fullName: parsedJson['full_name'],
    );
  }
}

class AssignedOrderActivities {
  final int count;
  final String next;
  final String previous;
  final List<AssignedOrderActivity> results;

  AssignedOrderActivities({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  factory AssignedOrderActivities.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['results'] as List;
    List<AssignedOrderActivity> results = list.map((i) => AssignedOrderActivity.fromJson(i)).toList();

    return AssignedOrderActivities(
      count: parsedJson['count'],
      next: parsedJson['next'],
      previous: parsedJson['previous'],
      results: results,
    );
  }
}
