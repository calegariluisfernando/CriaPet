import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../models/user.dart';
import '../services/maria_service.dart';

class UserNotifier extends ChangeNotifier {
  User _user = User();
  bool _localPhoto = false;

  bool get localPhoto => _localPhoto;
  set localPhoto(bool value) {
    _localPhoto = value;
    notifyListeners();
  }

  User get user => _user;
  set user(User value) {
    _user = value;
    notifyListeners();
  }

  void clear() {
    _user = User();
    _localPhoto = false;
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

      String? t = user.password;
      user = User.fromMap({
        'id': response.data['user']['id'],
        'uuid': response.data['user']['uuid'],
        'name': response.data['user']['name'],
        'apelido': response.data['user']['apelido'],
        'email': response.data['user']['email'],
        'token': response.data['token'],
        'photo_url': response.data['user']['photo'] != null
            ? '${service.dio.options.baseUrl}/user/photo/${response.data['user']['id']}'
            : '',
      });

      user.apelido = user.apelido!.isEmpty ? user.name : user.apelido;
      user.password = t;

      MariaService.instance
          .addHeaderDefaults({'Authorization': 'Bearer ${user.token}'});

      notifyListeners();
    } on DioException catch (e) {
      Map<String, dynamic> erro = e.response?.data;
      onError(erro['error']);
    }
  }
}
