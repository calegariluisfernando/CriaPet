import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../entities/user.dart';
import '../services/vml_http_service.dart';

class UserProvider extends ChangeNotifier {
  User user = User(name: '', email: '');

  void setUser(User user) {
    this.user = user;
    notifyListeners();
  }

  void clearUser() {
    user = User(name: '', email: '');
    notifyListeners();
  }

  Future<Map<String, dynamic>> login() async {
    VMLHttpService service = VMLHttpService.instance;
    try {
      Response response = await service.dio.post(
        '/auth/login',
        data: {'email': user.email, 'password': user.password},
      );

      if (response.statusCode == 200) {
        user = User.fromJson(response.data['user']);
      }
      return jsonDecode(
          '{"message": "success", "token": "${response.data['token']}"}');
    } on DioException catch (e) {
      return jsonDecode(
          '{"error": 1,"message": "${e.response?.data['message']}"}');
    }
  }
}
