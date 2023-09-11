import 'package:flutter/material.dart';
import 'package:petguardgui/Widgets/user_profile_photo.dart';

import '../Widgets/header_info.dart';
import '../my_default_settings.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final _formKey = GlobalKey<FormState>();

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
              end: Alignment.center,
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
                HeaderInfo(),
                SizedBox(height: MyDefaultSettings.gutter),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [UserProfilePhoto(size: 100)],
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Nome',
                          prefixIcon: Icon(Icons.email),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'O campo nome é obrigatório';
                          }
                          return null;
                        },
                      ),
                    ],
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
