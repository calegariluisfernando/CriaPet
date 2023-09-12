import 'package:flutter/material.dart';
import 'package:petguardgui/Widgets/user_profile_photo.dart';
import 'package:petguardgui/notifiers/user_notifier.dart';
import 'package:provider/provider.dart';

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
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  color: MyDefaultSettings.primaryColor,
                  child: SizedBox(height: 120),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: MyDefaultSettings.gutter,
                right: MyDefaultSettings.gutter,
                left: MyDefaultSettings.gutter,
              ),
              child: Consumer<UserNotifier>(
                builder: (context, userStore, child) {
                  print('Token: ${userStore.user.token}');
                  print('Url: ${userStore.user.photoUrl}');
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        HeaderInfo(),
                        SizedBox(height: MyDefaultSettings.gutter),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                UserProfilePhoto(
                                  size: 100,
                                  url: userStore.user.photoUrl,
                                  token: userStore.user.token,
                                ),
                              ],
                            ),
                          ],
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                decoration:
                                    const InputDecoration(labelText: 'Nome'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'O campo nome é obrigatório';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: MyDefaultSettings.gutter),
                              TextFormField(
                                decoration:
                                    const InputDecoration(labelText: 'Apelido'),
                              ),
                              SizedBox(height: MyDefaultSettings.gutter),
                              TextFormField(
                                decoration:
                                    const InputDecoration(labelText: 'E-mail'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'O campo e-mail é obrigatório';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: MyDefaultSettings.gutter),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      MyDefaultSettings.primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      MyDefaultSettings.gutter / 4,
                                    ),
                                  ),
                                ),
                                onPressed: () {},
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Salvar',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    SizedBox(
                                        width: MyDefaultSettings.gutter / 4),
                                    Icon(Icons.save, color: Colors.white),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
