import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'my_default_settings.dart';
import 'notifiers/user_notifier.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserNotifier()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CriaPet',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: MyDefaultSettings.primaryTextColor),
        useMaterial3: true,
      ),
      home: LoginScreen(),
    );
  }
}
