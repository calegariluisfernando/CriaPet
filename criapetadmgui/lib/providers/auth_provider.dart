import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  String _token = '';
  String get token => _token;

  Future<void> registerToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
    _token = token;

    notifyListeners();
  }

  Future<void> unregisterToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    _token = '';

    notifyListeners();
  }
}
