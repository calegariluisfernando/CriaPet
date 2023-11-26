import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'contranints.dart';
import 'entities/user.dart';
import 'providers/auth_provider.dart';
import 'providers/user_provider.dart';
import 'routes.dart';
import 'services/vml_http_service.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool isLoading = true;

  Future<void> _checkIsAuthenticated() async {
    VMLHttpService service = VMLHttpService.instance;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? '';

    AuthProvider authProvider = Provider.of<AuthProvider>(
      context,
      listen: false,
    );

    UserProvider userProvider = Provider.of<UserProvider>(
      context,
      listen: false,
    );

    if (token.isNotEmpty) {
      service.addHeaderToken(token);
      Response response = await service.dio.get('/auth/me');
      userProvider.setUser(User.fromJson(response.data));

      await authProvider.registerToken(token);
    }

    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    _checkIsAuthenticated();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : MaterialApp.router(
            title: 'ADM',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.white,
                primary: Colors.black,
                background: const Color(0xfff0f2f5),
              ),
              useMaterial3: true,
              brightness: Brightness.light,
              inputDecorationTheme: const InputDecorationTheme(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: defaultBorderColor),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: redColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: defaultFucusedBorderColor,
                    width: 2.0,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: redColor,
                    width: 2.0,
                  ),
                ),
                labelStyle: TextStyle(color: Colors.black87),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
            routerConfig: (MinhaRotas(context: context)).routes,
          );
  }
}
