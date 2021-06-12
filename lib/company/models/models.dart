class StudentUserProperty {
  final String? address;
  final String? postal;
  final String? city;
  final String? countryCode;
  final String? mobile;
  final String? remarks;
  final String? iBan;
  final String? picture;
  final String? info;

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
