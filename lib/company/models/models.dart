import 'dart:convert';

class StudentUserProperty {
  final String? street;
  final String? houseNumber;
  final String? houseNumberAddition;
  final String? postal;
  final String? city;
  final String? countryCode;
  final String? mobile;
  final String? remarks;
  final String? iBan;
  String? picture;
  final String? info;
  final String? gender;
  final String? dayOfBirth;
  final String? driversLicence;
  final String? driversLicenceType;
  final String? boxTruck;
  final String? bsn;
  final String? uuid;
  final String? vaccinated;
  final bool? isFirstTimeProfile;

  StudentUserProperty({
    this.street,
    this.houseNumber,
    this.houseNumberAddition,
    this.postal,
    this.city,
    this.countryCode,
    this.mobile,
    this.remarks,
    this.iBan,
    this.picture,
    this.info,
    this.gender,
    this.dayOfBirth,
    this.driversLicence,
    this.driversLicenceType,
    this.boxTruck,
    this.bsn,
    this.uuid,
    this.vaccinated,
    this.isFirstTimeProfile,
  });

  factory StudentUserProperty.fromJson(Map<String, dynamic> parsedJson) {
    return StudentUserProperty(
      street: parsedJson['street'],
      houseNumber: parsedJson['house_number'],
      houseNumberAddition: parsedJson['house_number_addition'],
      postal: parsedJson['postal'],
      city: parsedJson['city'],
      countryCode: parsedJson['country_code'],
      mobile: parsedJson['mobile'],
      remarks: parsedJson['remarks'],
      iBan: parsedJson['iban'],
      picture: parsedJson['picture'],
      info: parsedJson['info'],
      gender: parsedJson['gender'],
      dayOfBirth: parsedJson['dob'],
      driversLicence: parsedJson['drivers_licence'],
      driversLicenceType: parsedJson['drivers_licence_type'],
      boxTruck: parsedJson['box_truck'],
      bsn: parsedJson['bsn'],
      vaccinated: parsedJson['vaccinated'],
      uuid: parsedJson['uuid'],
    );
  }
}

class StudentUser {
  int? id;
  String email;
  String username;
  String? token;
  String? fullName;
  String? firstName;
  String? lastName;
  StudentUserProperty? studentUser;

  StudentUser({
    this.id,
    required this.email,
    required this.username,
    this.token,
    this.fullName,
    this.firstName,
    this.lastName,
    this.studentUser,
  });

  factory StudentUser.fromJson(Map<String, dynamic> parsedJson) {
    StudentUserProperty studentUser = StudentUserProperty.fromJson(parsedJson['student_user']);

    return StudentUser(
      id: parsedJson['id'],
      email: parsedJson['email'],
      username: parsedJson['username'],
      token: parsedJson['token'],
      fullName: parsedJson['full_name'],
      firstName: parsedJson['first_name'],
      lastName: parsedJson['last_name'],
      studentUser: studentUser,
    );
  }
}

class UserSettings {
  int? user;
  Map<String, dynamic>? settings;

  UserSettings({
    this.user,
    this.settings
  });

  factory UserSettings.fromJson(Map<String, dynamic> parsedJson) {
    return UserSettings(
        user: parsedJson['user'],
        settings: parsedJson['settings']
    );
  }
}

class SlidingToken {
  final String? token;
  Map<String, dynamic>? raw;
  bool? isValid;
  bool? isExpired;

  SlidingToken({
    this.token,
    this.isValid,
    this.isExpired,
    this.raw,
  });

  Map<String, dynamic> getPayload() {
    var parts = token!.split(".");
    return json.decode(ascii.decode(base64.decode(base64.normalize(parts[1]))));
  }

  int getUserPk() {
    var payload = getPayload();
    return payload['user_id'];
  }

  void checkIsTokenValid() {
    var parts = token!.split(".");
    isValid = parts.length == 3 ? true : false;
  }

  factory SlidingToken.fromJson(Map<String, dynamic> parsedJson) {
    return SlidingToken(
      token: parsedJson['token'],
      raw: parsedJson,
    );
  }
}
