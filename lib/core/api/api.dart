import 'package:jobhop/utils/generic.dart';
import 'package:jobhop/core/app_config.dart';

mixin ApiMixin {
  String? token;
  Map<String, String> headers = {"Content-Type": "application/json; charset=UTF-8"};

  String getUrl(String path) {
    return "https://${config.apiBaseUrl}$path";
  }

  Future<Map<String, String>?> getHeaders() async {
    if(!headers.containsKey('Authorization')) {
      token = await getToken();

      headers.addAll({'Authorization': 'Token $token'});
    }

    return headers;
  }
}
