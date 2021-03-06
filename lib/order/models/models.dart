import 'dart:convert';

class Orderline {
  final String? product;
  final String? location;
  final String? remarks;

  Orderline({
    this.product,
    this.location,
    this.remarks,
  });

  factory Orderline.fromJson(Map<String, dynamic> parsedJson) {
    return Orderline(
      product: parsedJson['product'],
      location: parsedJson['location'],
      remarks: parsedJson['remarks'],
    );
  }
}

class Infoline {
  final String? info;

  Infoline({
    this.info,
  });

  factory Infoline.fromJson(Map<String, dynamic> parsedJson) {
    return Infoline(
      info: parsedJson['info'],
    );
  }
}

class Status {
  final int? id;
  final int? orderId;
  final String? status;
  final String? modified;
  final String? created;

  Status({
    this.id,
    this.orderId,
    this.status,
    this.modified,
    this.created,
  });

  factory Status.fromJson(Map<String, dynamic> parsedJson) {
    return Status(
      id: parsedJson['id'],
      orderId: parsedJson['order'],
      status: parsedJson['status'],
      modified: parsedJson['modified'],
      created: parsedJson['created'],
    );
  }
}

class OrderDocument {
  final int? id;
  final int? orderId;
  final String? name;
  final String? description;
  final String? file;
  final String? url;

  OrderDocument({
    this.id,
    this.orderId,
    this.name,
    this.description,
    this.file,
    this.url,
  });

  factory OrderDocument.fromJson(Map<String, dynamic> parsedJson) {
    return OrderDocument(
      id: parsedJson['id'],
      orderId: parsedJson['order'],
      name: parsedJson['name'],
      description: parsedJson['description'],
      file: parsedJson['file'],
      url: parsedJson['url'],
    );
  }
}

class OrderDocuments {
  final int? count;
  final String? next;
  final String? previous;
  final List<OrderDocument>? results;

  OrderDocuments({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  factory OrderDocuments.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['results'] as List;
    List<OrderDocument> results = list.map((i) => OrderDocument.fromJson(i)).toList();

    return OrderDocuments(
        count: parsedJson['count'],
        next: parsedJson['next'],
        previous: parsedJson['previous'],
        results: results
    );
  }
}

class Order {
  final int? id;
  final String? customerId;
  final int? customerRelation;
  final String? orderId;
  final String? serviceNumber;
  final String? orderReference;
  final String? orderType;
  final String? customerRemarks;
  final String? description;
  final String? startDate;
  final String? startTime;
  final String? endDate;
  final String? endTime;
  final String? orderDate;
  final String? lastStatus;
  final String? orderName;
  final String? orderAddress;
  final String? orderPostal;
  final String? orderCity;
  final String? orderCountryCode;
  final String? orderTel;
  final String? orderMobile;
  final String? orderEmail;
  final String? orderContact;
  final String? lastStatusFull;
  final int? requireUsers;
  final String? created;
  final String? totalPricePurchase;
  final String? totalPriceSelling;
  final String? workorderPdfUrl;
  final bool? customerOrderAccepted;
  final List<Orderline>? orderLines;
  final List<Infoline>? infoLines;
  final List<Status>? statusses;
  final List<OrderDocument>? documents;

  Order({
    this.id,
    this.customerId,
    this.customerRelation,
    this.orderId,
    this.serviceNumber,
    this.orderReference,
    this.orderType,
    this.customerRemarks,
    this.description,
    this.startDate,
    this.startTime,
    this.endDate,
    this.endTime,
    this.lastStatus,
    this.orderName,
    this.orderAddress,
    this.orderPostal,
    this.orderCity,
    this.orderCountryCode,
    this.orderTel,
    this.orderMobile,
    this.orderContact,
    this.lastStatusFull,
    this.requireUsers,
    this.created,
    this.totalPricePurchase,
    this.totalPriceSelling,
    this.orderDate,
    this.orderEmail,
    this.workorderPdfUrl,
    this.customerOrderAccepted,
    this.orderLines,
    this.infoLines,
    this.statusses,
    this.documents,
  });

  factory Order.fromJson(Map<String, dynamic> parsedJson) {
    // order lines
    List<Orderline> orderlines = [];
    if (parsedJson.containsKey('orderlines')) {
      var parsedOrderlines = parsedJson['orderlines'] as List;

      orderlines =
          parsedOrderlines.map((i) => Orderline.fromJson(i)).toList();
    }

    // info lines
    List<Infoline> infolines = [];
    if (parsedJson.containsKey('infolines')) {
      var parsedInfolines = parsedJson['infolines'] as List;

      infolines = parsedInfolines.map((i) => Infoline.fromJson(i)).toList();
    }

    // statusses
    List<Status> statusses = [];
    if (parsedJson.containsKey('statusses')) {
      var parsedStatusses = parsedJson['statusses'] as List;

      statusses = parsedStatusses.map((i) => Status.fromJson(i)).toList();
    }

    // documents
    List<OrderDocument> documents = [];
    if (parsedJson.containsKey('statusses')) {
      var parsedDocuments = parsedJson['documents'] as List;

      documents =
          parsedDocuments.map((i) => OrderDocument.fromJson(i)).toList();
    }

    return Order(
      id: parsedJson['id'],
      customerId: parsedJson['customer_id'],
      customerRelation: parsedJson['customer_relation'],
      orderId: parsedJson['order_id'],
      serviceNumber: parsedJson['service_number'],
      orderReference: parsedJson['order_reference'],
      orderType: parsedJson['order_type'],
      customerRemarks: parsedJson['customer_remarks'],
      description: parsedJson['description'],
      startDate: parsedJson['start_date'],
      startTime: parsedJson['start_time'],
      endDate: parsedJson['end_date'],
      endTime: parsedJson['end_time'],
      lastStatus: parsedJson['last_status'],
      orderName: parsedJson['order_name'],
      orderAddress: parsedJson['order_address'],
      orderPostal: parsedJson['order_postal'],
      orderCity: parsedJson['order_city'],
      orderCountryCode: parsedJson['order_country_code'],
      orderTel: parsedJson['order_tel'],
      orderMobile: parsedJson['order_mobile'],
      orderContact: parsedJson['order_contact'],
      lastStatusFull: parsedJson['last_status_full'],
      requireUsers: parsedJson['required_users'],
      created: parsedJson['created'],
      totalPricePurchase: parsedJson['total_price_purchase'],
      totalPriceSelling: parsedJson['total_price_selling'],
      orderEmail: parsedJson['order_email'],
      orderDate: parsedJson['order_date'],
      workorderPdfUrl: parsedJson['workorder_pdf_url'],
      customerOrderAccepted: parsedJson['customer_order_accepted'],
      orderLines: orderlines,
      infoLines: infolines,
      statusses: statusses,
      documents: documents,
    );
  }
}

class StartCode {
  final int? id;
  final String? statuscode;
  final String? description;

  StartCode({
    this.id,
    this.statuscode,
    this.description,
  });

  factory StartCode.fromJson(Map<String, dynamic> parsedJson) {
    return StartCode(
        id: parsedJson['id'],
        statuscode: parsedJson['statuscode'],
        description: parsedJson['description'],
    );
  }
}

class EndCode {
  final int? id;
  final String? statuscode;
  final String? description;

  EndCode({
    this.id,
    this.statuscode,
    this.description,
  });

  factory EndCode.fromJson(Map<String, dynamic> parsedJson) {
    return EndCode(
      id: parsedJson['id'],
      statuscode: parsedJson['statuscode'],
      description: parsedJson['description'],
    );
  }
}
