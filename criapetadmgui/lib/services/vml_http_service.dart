import 'package:dio/dio.dart';

import '../contranints.dart';

class VMLHttpService {
  static final VMLHttpService _instance = VMLHttpService._internal();
  static VMLHttpService get instance => _instance;
  Dio dio = Dio(BaseOptions(baseUrl: baseUrl));

  VMLHttpService._internal();

  factory VMLHttpService() => _instance;

  void addHeaderToken(String token) {
    addHeaderDefaults({'Authorization': 'Bearer $token'});
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
