import 'package:easy_localization/easy_localization.dart';
import 'package:jobhop/company/models/models.dart';
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
    if (parsedJson.containsKey('start_codes')) {
      var parsedStartCodesList = parsedJson['start_codes'] as List;
      startCodes = parsedStartCodesList.map((i) => StartCode.fromJson(i)).toList();
    }

    List<EndCode> endCodes = [];
    if (parsedJson.containsKey('end_codes')) {
      var parsedEndCodesList = parsedJson['end_codes'] as List;
      endCodes = parsedEndCodesList.map((i) => EndCode.fromJson(i)).toList();
    }

    Customer customer;
    if (parsedJson.containsKey('customer')) {
      customer = Customer.fromJson(parsedJson['customer']);
    }

    List<AssignedUserdata> assignedUsers = [];
    if (parsedJson.containsKey('assigned_userdata')) {
      var parsedUserData = parsedJson['assigned_userdata'] as List;
      assignedUsers =
          parsedUserData.map((i) => AssignedUserdata.fromJson(i)).toList();
    }

    return AssignedOrder(
      id: parsedJson['id'],
      order: Order.fromJson(parsedJson['order']),
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
  final int? distanceFixedRateAmount;
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
    this.distanceFixedRateAmount,
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
      distanceFixedRateAmount: parsedJson['distance_fixed_rate_amount'],
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

class TripOrder {
  final int id;
  final int order;
  final String name;
  final String address;
  final String postal;
  final String city;
  final String countryCode;
  final String date;
  final DateTime startDate;
  final DateTime endDate;

  TripOrder({
    required this.id,
    required this.order,
    required this.name,
    required this.address,
    required this.postal,
    required this.city,
    required this.countryCode,
    required this.date,
    required this.startDate,
    required this.endDate,
  });

  factory TripOrder.fromJson(Map<String, dynamic> parsedJson) {
    final parsedStartDate = parsedJson['start_date'];
    final parsedStartTime = parsedJson['start_time'];
    final parsedEndDate = parsedJson['end_date'];
    final parsedEndTime = parsedJson['end_time'];

    DateTime startDate = DateFormat('yyyy-M-d H:m:s').parse('1970-01-01 00:00:00');
    if (parsedStartDate != null && parsedStartTime != null) {
      startDate = DateFormat('yyyy-M-d H:m:s').parse('$parsedStartDate $parsedStartTime');
    }

    DateTime endDate = DateFormat('yyyy-M-d H:m:s').parse('1970-01-01 00:00:00');
    if (parsedEndDate != null && parsedEndTime != null) {
      endDate = DateFormat('yyyy-M-d H:m:s').parse('$parsedEndDate $parsedEndTime');
    }

    return TripOrder(
      id: parsedJson['id'],
      order: parsedJson['order'],
      name: parsedJson['name'],
      address: parsedJson['address'],
      postal: parsedJson['postal'],
      city: parsedJson['city'],
      countryCode: parsedJson['country_code'],
      date: parsedJson['date'],
      startDate: startDate,
      endDate: endDate,
    );
  }
}

class Trip {
  final int id;
  final String description;
  final int requiredUsers;
  final String startDate;
  final String startTime;
  final String endDate;
  final String endTime;
  final String tripDate;
  final bool userTripIsAvailable;  // if the user has already set this trip as being available
  final String requiredAssigned;  // text field with num_assigned, required_users, and a percentage of those
  final int assignedUserCount;  // the number of users already assigned to this trip
  final int numOrders;  // this number of orders in this trip
  final int usersTripSetAsAvailable;  // the number of users that has set this trip as being available
  final int numberStillAvailable;  // required_users - users_trip_set_as_available
  final List<TripOrder> tripOrders;

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
    var tripOrdersList = parsedJson['trip_orders'] as List;
    List<TripOrder> tripOrders = tripOrdersList.map((i) => TripOrder.fromJson(i)).toList();

    return Trip(
      id: parsedJson['id'],
      description: parsedJson['description'],
      requiredUsers: parsedJson['required_users'],
      startDate: parsedJson['start_date'],
      startTime: parsedJson['start_time'],
      endDate: parsedJson['end_date'],
      endTime: parsedJson['end_time'],
      tripDate: parsedJson['trip_date'],
      userTripIsAvailable: parsedJson['user_trip_is_available'],
      requiredAssigned: parsedJson['required_assigned'],
      assignedUserCount: parsedJson['assigned_user_count'],
      numOrders: parsedJson['num_orders'],
      numberStillAvailable: parsedJson['number_still_available'],
      usersTripSetAsAvailable: parsedJson['users_trip_set_as_available'],
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

class TripUserAvailability {
  final int id;
  final StudentUser user;
  final int tripPk;
  final bool isAccepted;
  final String description;
  final String tripDate;
  final String created;
  final String modified;

  TripUserAvailability({
    required this.id,
    required this.user,
    required this.tripPk,
    required this.isAccepted,
    required this.description,
    required this.tripDate,
    required this.created,
    required this.modified,
  });

  factory TripUserAvailability.fromJson(Map<String, dynamic> parsedJson) {
    StudentUser user = StudentUser.fromJson(parsedJson['user']);

    return TripUserAvailability(
        id: parsedJson['id'],
        user: user,
        tripPk: parsedJson['trip'],
        isAccepted: parsedJson['is_accepted'],
        description: parsedJson['description'],
        tripDate: parsedJson['trip_date'],
        created:parsedJson['created'],
        modified:parsedJson['modified'],
    );
  }
}

class TripUserAvailabilities {
  final int count;
  final String? next;
  final String? previous;
  final List<TripUserAvailability> results;

  TripUserAvailabilities({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  factory TripUserAvailabilities.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['results'] as List;
    List<TripUserAvailability> results = list.map((i) => TripUserAvailability.fromJson(i)).toList();

    return TripUserAvailabilities(
      count: parsedJson['count'],
      next: parsedJson['next'],
      previous: parsedJson['previous'],
      results: results,
    );
  }
}
