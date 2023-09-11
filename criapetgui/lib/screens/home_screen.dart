import 'package:flutter/material.dart';
import 'package:petguardgui/screens/user_info_screen.dart';

import '../Widgets/header_info.dart';
import '../my_default_settings.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          padding: EdgeInsets.all(MyDefaultSettings.gutter),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                MyDefaultSettings.primaryColor,
                Colors.white,
              ],
              stops: [.5, .5],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                HeaderInfo(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserInfoScreen(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
