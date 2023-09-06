import 'package:flutter/foundation.dart';

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

  Future<void> login(String email, String password) async {
    print('login');
    notifyListeners();
  }
}
