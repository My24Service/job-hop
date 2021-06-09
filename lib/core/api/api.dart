import 'package:shared_preferences/shared_preferences.dart';

mixin ApiMixin {
  late final String? baseUrl;
  late final Map<String, String>? headers;

  Future<String?> getUrl(String path) async {
    if(baseUrl != null) {
      return baseUrl;
    }

    final prefs = await SharedPreferences.getInstance();
    String? companycode = prefs.getString('companycode');
    String? apiBaseUrl = prefs.getString('apiBaseUrl');

    if (companycode == null || companycode == '' || companycode == 'jansenit') {
      companycode = 'demo';
    }

    if (apiBaseUrl == null || apiBaseUrl == '') {
      apiBaseUrl = 'my24service-dev.com';
    }

    baseUrl = 'https://$companycode.$apiBaseUrl$path';
    print('setting class baseUrl to: $baseUrl');
    return baseUrl;
  }

  Future<Map<String, String>?> getHeaders() async {
    if(headers != null) {
      return headers;
    }

    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    Map<String, String> allHeaders = {"Content-Type": "application/json; charset=UTF-8"};
    allHeaders.addAll({'Authorization': 'Bearer $token'});

    headers = allHeaders;
    return headers;
  }
}
