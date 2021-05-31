class StudentUserProperty {
  final String address;
  final String postal;
  final String city;
  final String countryCode;
  final String mobile;
  final String remarks;
  final String iBan;
  final String picture;
  final String info;

  StudentUserProperty({
    required this.address,
    required this.postal,
    required this.city,
    required this.countryCode,
    required this.mobile,
    required this.remarks,
    required this.iBan,
    required this.picture,
    required this.info,
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
  final int id;
  final String email;
  final String username;
  final String fullName;
  final String firstName;
  final String lastName;
  StudentUserProperty studentUser;

  StudentUser({
    required this.id,
    required this.email,
    required this.username,
    required this.fullName,
    required this.firstName,
    required this.lastName,
    required this.studentUser,
  });

  factory StudentUser.fromJson(Map<String, dynamic> parsedJson) {
    StudentUserProperty studentUser = StudentUserProperty.fromJson(parsedJson['student_user']);

    return StudentUser(
      id: parsedJson['id'],
      email: parsedJson['email'],
      username: parsedJson['username'],
      fullName: parsedJson['full_name'],
      firstName: parsedJson['first_name'],
      lastName: parsedJson['last_name'],
      studentUser: studentUser,
    );
  }
}
