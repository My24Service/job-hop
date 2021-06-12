import 'package:jobhop/utils/generic.dart';
import 'package:jobhop/core/app_config.dart';

mixin ApiMixin {
  String getUrl(String path) {
    return "https://${config.apiBaseUrl}$path";
  }

  Future<Map<String, String>> getHeaders() async {
    Map<String, String> headers = {"Content-Type": "application/json; charset=UTF-8"};
    String? token = await getToken();

    if (token != null) {
      headers.addAll({'Authorization': 'Token $token'});
    }

    return headers;
  }
}
