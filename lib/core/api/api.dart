import 'package:jobhop/utils/generic.dart';
import 'package:jobhop/core/app_config.dart';
import 'package:get_it/get_it.dart';

import 'package:jobhop/utils/state.dart';

GetIt getIt = GetIt.instance;

mixin ApiMixin {
  String getUrl(String path) {
    final isDemo = getIt<AppModel>().isDemo;
    final String baseUrl = isDemo ? config.demoApiBaseUrl : config.apiBaseUrl;
    return "https://$baseUrl$path";
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
