class StudentUserProperty {
  final String? address;
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

  StudentUserProperty({
    this.address,
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
    this.bsn
  });

  factory StudentUserProperty.fromJson(Map<String, dynamic> parsedJson) {
    return StudentUserProperty(
      address: parsedJson['address'],
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
