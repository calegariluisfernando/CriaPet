import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../Services/maria_service.dart';
import '../models/user.dart';

class UserNotifier extends ChangeNotifier {
  User _user = User();

  User get user => _user;
  set user(User value) {
    _user = value;
    notifyListeners();
  }

  void clear() {
    _user = User();
    notifyListeners();
  }

  Future<void> login(Function(String message) onError) async {
    try {
      MariaService service = MariaService.instance;
      var response = await service.dio.post(
        '/auth/login',
        data: jsonEncode({
          'email': user.email,
          'password': user.password,
        }),
      );

      user.id = response.data['user']['id'];
      user.uuid = response.data['user']['uuid'];
      user.name = response.data['user']['name'];
      user.apelido = response.data['user']['apelido'];
      user.email = response.data['user']['email'];
      user.token = response.data['token'];

      user.photoUrl = response.data['user']['photo'] != null
          ? '${service.dio.options.baseUrl}/user/photo/${response.data['user']['id']}'
          : '';

      notifyListeners();
    } on DioException catch (e) {
      Map<String, dynamic> erro = e.response?.data;
      onError(erro['error']);
    }
  }
}
