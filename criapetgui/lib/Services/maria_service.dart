import 'package:dio/dio.dart';

import '../my_default_settings.dart';

class MariaService {
  static final MariaService _instance = MariaService._internal();
  static MariaService get instance => _instance;
  Dio dio = Dio(BaseOptions(baseUrl: MyDefaultSettings.apiUrl));

  MariaService._internal();

  factory MariaService() {
    return _instance;
  }

  void addHeaderDefaults(Map<String, dynamic> newHeader) {
    Map<String, dynamic> myHeaders = dio.options.headers;
    for (var key in newHeader.keys) {
      myHeaders[key] = newHeader[key];
    }

    dio.options.headers = myHeaders;
  }

  void removeHeaderDefaults(Map<String, dynamic> headers) {
    Map<String, dynamic> myHeaders = dio.options.headers;
    for (var key in headers.keys) {
      if (myHeaders.containsKey(key)) {
        myHeaders.remove(key);
      }
    }

    dio.options.headers = myHeaders;
  }
}
