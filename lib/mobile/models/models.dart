import 'package:jobhop/order/models/models.dart';
import 'package:jobhop/customer/models/models.dart';

class AssignedUserdata {
  final String? fullName;
  final String? mobile;

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
  final int? id;
  final int? engineer;
  final int? studentUser;
  final Order? order;
  bool? isStarted;
  final bool? isEnded;
  final Customer? customer;
  final List<StartCode>? startCodes;
  final List<EndCode>? endCodes;
  final List<AssignedUserdata>? assignedUserData;

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
      startCodes: startCodes,
      endCodes: endCodes,
      assignedUserData: assignedUsers,
    );
  }
}

class AssignedOrders {
  final int count;
  final String? next;
  final String? previous;
  final List<AssignedOrder> results;

  AssignedOrders({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
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
  final int? id;
  final String? activityDate;
  final int? assignedOrderId;
  final String? workStart;
  final String? workEnd;
  final String? travelTo;
  final String? travelBack;
  final int? odoReadingToStart;
  final int? odoReadingToEnd;
  final int? odoReadingBackStart;
  final int? odoReadingBackEnd;
  final int? distanceTo;
  final int? distanceBack;
  final String? fullName;

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
  final String? next;
  final String? previous;
  final List<AssignedOrderActivity> results;

  AssignedOrderActivities({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
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

// {"next":null,"previous":null,"count":1,"num_pages":1,"results":[
// {"id":9,
// "description":"tets",
// "required_users":5,
// "trip_orders":[{"id":18,"order":62,"name":"De Kerstmarktspecialist","address":"Metaalweg 4","city":"Bunschoten","date":"14/06/2021","modified":"13/06/2021 10:32","created":"13/06/2021 10:32"}],
// "start_date":"2021-06-21",
// "start_time":"12:15:00",
// "end_date":"2021-06-23",
// "end_time":"13:00:00",
// "trip_date":"21/06/2021 12:15 - 23/06/2021 13:00",
// "user_trip_is_available":true,
// "required_assigned":"-",
// "assigned_user_count":0,
// "num_orders":1,
// "users_trip_set_as_available":0,
// "number_still_available":5
// }
// ]}
class Trip {
  final int id;
  final String description;
  final int requiredUsers;
  final String startDate;
  final String startTime;
  final String endDate;
  final String endTime;
  final String tripDate;
  final bool userTripIsAvailable;
  final String requiredAssigned;
  final int assignedUserCount;
  final int numOrders;
  final int usersTripSetAsAvailable;
  final int numberStillAvailable;
  final List<Order> tripOrders;

  Trip({
    required this.id,
    required this.description,
    required this.requiredUsers,
    required this.startDate,
    required this.startTime,
    required this.endDate,
    required this.endTime,
    required this.tripDate,
    required this.userTripIsAvailable,
    required this.requiredAssigned,
    required this.assignedUserCount,
    required this.numOrders,
    required this.usersTripSetAsAvailable,
    required this.numberStillAvailable,
    required this.tripOrders
  });

  factory Trip.fromJson(Map<String, dynamic> parsedJson) {
    var orders = parsedJson['tripOrders'] as List;
    List<Order> tripOrders = orders.map((i) => Order.fromJson(i)).toList();

    return Trip(
      id: parsedJson['id'],
      description: parsedJson['description'],
      requiredUsers: parsedJson['required_users'],
      startDate: parsedJson['start_date'],
      startTime: parsedJson['start_time'],
      endDate: parsedJson['end_date'],
      endTime: parsedJson['end_time'],
      tripDate: parsedJson['trip_date'],
      usersTripSetAsAvailable: parsedJson['user_trip_is_available'],
      requiredAssigned: parsedJson['required_assigned'],
      assignedUserCount: parsedJson['assigned_user_count'],
      numOrders: parsedJson['num_orders'],
      userTripIsAvailable: parsedJson['num_orders'],
      numberStillAvailable: parsedJson['number_still_available'],
      tripOrders: tripOrders,
    );
  }
}

class Trips {
  final int count;
  final String? next;
  final String? previous;
  final List<Trip> results;

  Trips({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  factory Trips.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['results'] as List;
    List<Trip> results = list.map((i) => Trip.fromJson(i)).toList();

    return Trips(
      count: parsedJson['count'],
      next: parsedJson['next'],
      previous: parsedJson['previous'],
      results: results,
    );
  }
}
