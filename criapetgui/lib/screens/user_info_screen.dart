import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:petguardgui/Services/maria_service.dart';
import 'package:petguardgui/Widgets/user_profile_photo.dart';
import 'package:petguardgui/notifiers/user_notifier.dart';
import 'package:provider/provider.dart';

import '../Widgets/header_info.dart';
import '../models/user.dart';
import '../my_default_settings.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController txtNome = TextEditingController();
  late TextEditingController txtApelido = TextEditingController();
  late TextEditingController txtEmail = TextEditingController();

  @override
  void initState() {
    super.initState();

    UserNotifier userNotifier =
        Provider.of<UserNotifier>(context, listen: false);

    txtNome.text = userNotifier.user.name!;
    txtApelido.text = userNotifier.user.apelido!;
    txtEmail.text = userNotifier.user.email!;
  }

  bool isSaving = false;
  void toggleIsSaving() {
    setState(() {
      isSaving = !isSaving;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: MyDefaultSettings.primaryColor,
          title: const HeaderInfo(),
        ),
        body: Consumer<UserNotifier>(
          builder: (context, UserNotifier userNotifier, child) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
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
                    child: Column(
                      children: [
                        SizedBox(height: MyDefaultSettings.gutter),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            UserProfilePhoto(
                              size: 100,
                              url: userNotifier.user.photoUrl,
                              token: userNotifier.user.token,
                            ),
                          ],
                        ),
                        SizedBox(height: MyDefaultSettings.gutter),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: MyDefaultSettings.gutter,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: txtNome,
                            enabled: !isSaving,
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
                            controller: txtEmail,
                            enabled: !isSaving,
                            keyboardType: TextInputType.emailAddress,
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
                          TextFormField(
                            controller: txtApelido,
                            enabled: !isSaving,
                            decoration:
                                const InputDecoration(labelText: 'Apelido'),
                          ),
                          SizedBox(height: MyDefaultSettings.gutter),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: MyDefaultSettings.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  MyDefaultSettings.gutter / 4,
                                ),
                              ),
                            ),
                            onPressed: isSaving
                                ? null
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      toggleIsSaving();

                                      txtNome.text = txtNome.text.trim();
                                      txtApelido.text = txtApelido.text.trim();
                                      txtEmail.text = txtEmail.text.trim();

                                      userNotifier.user.apelido =
                                          txtApelido.text.isEmpty
                                              ? txtNome.text.split(' ')[0]
                                              : txtApelido.text;

                                      MariaService ms = MariaService.instance;
                                      ms.dio.post(
                                        '/user/${userNotifier.user.id}?_method=PUT',
                                        data: jsonEncode({
                                          'name': userNotifier.user.name,
                                          'apelido': userNotifier.user.apelido,
                                          'email': userNotifier.user.email,
                                        }),
                                      );

                                      userNotifier.user = User.fromMap(
                                        userNotifier.user.toMap(),
                                      );

                                      toggleIsSaving();

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Dados salvos com sucesso',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Ops! Algo deu errado.',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Salvar',
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(width: MyDefaultSettings.gutter / 4),
                                Icon(Icons.save, color: Colors.white),
                                if (isSaving)
                                  Row(
                                    children: [
                                      SizedBox(
                                          width: MyDefaultSettings.gutter / 4),
                                      SizedBox(
                                        width: MyDefaultSettings.gutter,
                                        height: MyDefaultSettings.gutter,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 1,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
