import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:easy_localization/easy_localization.dart';
import 'package:jobhop/company/models/models.dart';
import 'package:jobhop/core/api/api.dart';


class CompanyApi with ApiMixin {
  // default and setable for tests
  http.Client _httpClient = new http.Client();

  set httpClient(http.Client client) {
    _httpClient = client;
  }

  Future<StudentUser> fetchStudentUser(int userPk) async {
    final String? url = await getUrl('/company/studentuser/$userPk/');
    final response = await _httpClient.get(
        Uri.parse(url!),
        headers: await getHeaders()
    );

    if (response.statusCode == 200) {
      return StudentUser.fromJson(json.decode(response.body));
    }

    throw Exception('company.exception_fetch'.tr());
  }

  Future<bool> updateStudentUser(StudentUser user) async {
    final String? url = await getUrl('/company/studentuser/${user.id}/');

    final Map studentUserBody = {
      'address': user.studentUser!.address,
      'postal': user.studentUser!.postal,
      'city': user.studentUser!.city,
      'country_code': user.studentUser!.countryCode,
      'mobile': user.studentUser!.mobile,
      'remarks': user.studentUser!.remarks,
      'iban': user.studentUser!.iBan,
      'info': user.studentUser!.info,
    };

    final Map body = {
      'first_name': user.firstName,
      'last_name': user.lastName,
      'student_user': studentUserBody,
    };

    final response = await _httpClient.put(
        Uri.parse(url!),
        body: json.encode(body),
        headers: await getHeaders()
    );

    if (response.statusCode == 200) {
      return true;
    }

    throw Exception('orders.assign.exception_fetch_engineers'.tr());
  }

}

CompanyApi companyApi = CompanyApi();
