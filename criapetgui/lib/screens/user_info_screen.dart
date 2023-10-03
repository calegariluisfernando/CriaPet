import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../my_default_settings.dart';
import '../notifiers/user_notifier.dart';
import '../services/maria_service.dart';
import '../widgets/camera_preview.dart';
import '../widgets/header_info.dart';
import '../widgets/user_profile_photo.dart';

class UserInfoScreen extends StatefulWidget {
  final bool isNewUser;

  const UserInfoScreen({super.key, this.isNewUser = false});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController txtNome = TextEditingController();
  late TextEditingController txtApelido = TextEditingController();
  late TextEditingController txtEmail = TextEditingController();
  late TextEditingController txtPassword = TextEditingController();
  late TextEditingController txtRePassword = TextEditingController();

  bool isSaving = false;

  void toggleIsSaving() {
    setState(() {
      isSaving = !isSaving;
    });
  }

  @override
  void initState() {
    super.initState();

    UserNotifier userNotifier =
        Provider.of<UserNotifier>(context, listen: false);

    if (widget.isNewUser) {
      txtNome.text = '';
      txtApelido.text = '';
      txtEmail.text = '';
    } else {
      txtNome.text = userNotifier.user.name!;
      txtApelido.text = userNotifier.user.apelido!;
      txtEmail.text = userNotifier.user.email!;
    }
  }

  salvarUsuario() {
    return widget.isNewUser ? _salvarNovoUsuario() : _salvarAlteracaoUsuario();
  }

  _salvarAlteracaoUsuario() async {
    UserNotifier userNotifier =
        Provider.of<UserNotifier>(context, listen: false);

    if (_formKey.currentState!.validate()) {
      toggleIsSaving();

      txtNome.text = txtNome.text.trim();
      txtApelido.text = txtApelido.text.trim();
      txtEmail.text = txtEmail.text.trim();

      userNotifier.user.apelido = txtApelido.text.isEmpty
          ? txtNome.text.split(' ')[0]
          : txtApelido.text;

      Map<String, dynamic> data = {
        'name': txtNome.text,
        'apelido': txtApelido.text,
        'email': txtEmail.text,
      };

      if (userNotifier.localPhoto) {
        String filePath = userNotifier.user.photoUrl ?? '';

        File file = File(filePath);
        String fileName = file.path.split('/').last;

        data['photo'] = await MultipartFile.fromFile(
          filePath,
          filename: fileName,
        );
      }

      MariaService ms = MariaService.instance;
      final FormData formData = FormData.fromMap(data);

      try {
        var response = await ms.dio.post(
          '/user/${userNotifier.user.id}?_method=PUT',
          data: formData,
        );

        User user = userNotifier.user;

        user.name = response.data['name'];
        user.email = response.data['email'];
        user.apelido = response.data['apelido'];

        userNotifier.user = user;
        toggleIsSaving();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Dados salvos com sucesso',
              textAlign: TextAlign.center,
            ),
          ),
        );
      } on DioException catch (e) {
        late String msg;
        if (e.response != null) {
          Map<String, dynamic> erro = e.response?.data;
          msg = erro['error'];
        } else {
          msg = 'Erro Desconhecido';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              msg,
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Ops! Algo deu errado.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  _salvarNovoUsuario() async {
    UserNotifier userNotifier =
        Provider.of<UserNotifier>(context, listen: false);

    if (_formKey.currentState!.validate()) {
      toggleIsSaving();

      txtNome.text = txtNome.text.trim();
      txtApelido.text = txtApelido.text.trim();
      txtEmail.text = txtEmail.text.trim();

      Map<String, dynamic> data = {
        'name': txtNome.text,
        'apelido': txtApelido.text.isEmpty
            ? txtNome.text.split(' ')[0]
            : txtApelido.text,
        'email': txtEmail.text,
        'password': txtPassword.text,
      };

      if (userNotifier.localPhoto) {
        String filePath = userNotifier.user.photoUrl ?? '';

        File file = File(filePath);
        String fileName = file.path.split('/').last;

        data['photo'] = await MultipartFile.fromFile(
          filePath,
          filename: fileName,
        );
      }

      MariaService ms = MariaService.instance;
      final FormData formData = FormData.fromMap(data);

      try {
        await ms.dio.post(
          '/user',
          data: formData,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Usuário Cadastrado com Sucesso',
              textAlign: TextAlign.center,
            ),
          ),
        );

        toggleIsSaving();
        Navigator.of(context).pop();
      } on DioException catch (e) {
        late String msg;
        if (e.response != null) {
          Map<String, dynamic> erro = e.response?.data;
          msg = erro['error'];
        } else {
          msg = 'Erro Desconhecido';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              msg,
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Ops! Algo deu errado.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: MyDefaultSettings.primaryColor,
          title: const HeaderInfo(),
          automaticallyImplyLeading: false,
        ),
        body: Consumer<UserNotifier>(
          builder: (context, UserNotifier userNotifier, child) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  HeaderPhoto(),
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
                          if (widget.isNewUser)
                            Column(
                              children: [
                                TxtObscureText(
                                  txtController: txtPassword,
                                  txtLabel: 'Senha',
                                  isObscure: true,
                                  isEnable: !isSaving,
                                  validatorFunction: (String? value) {
                                    if (value == null ||
                                        value != txtPassword.text) {
                                      return 'O campo e-mail é obrigatório';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: MyDefaultSettings.gutter),
                                TxtObscureText(
                                  txtController: txtRePassword,
                                  txtLabel: 'Repetir Senha',
                                  isObscure: true,
                                  isEnable: !isSaving,
                                  validatorFunction: (String? value) {
                                    if (value == null ||
                                        value != txtPassword.text) {
                                      return 'O campo Repetir Senha deve ser igual ao campo Senha';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: MyDefaultSettings.gutter),
                              ],
                            ),
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
                            onPressed: isSaving ? null : salvarUsuario,
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

class HeaderPhoto extends StatelessWidget {
  const HeaderPhoto({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserNotifier>(
      builder: (context, userNotifier, child) => Container(
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
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    UserProfilePhoto(
                      size: 100,
                      url: userNotifier.user.photoUrl,
                      token: userNotifier.user.token,
                      isLocalPhoto: userNotifier.localPhoto,
                    ),
                    InkWell(
                      onTap: () async {
                        String? filePath = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyCameraPreview(),
                          ),
                        );

                        if (filePath != null) {
                          userNotifier.user.photoUrl = filePath;
                          userNotifier.localPhoto = true;
                        }
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          color: MyDefaultSettings.primaryColor.withOpacity(.8),
                        ),
                        child: Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: MyDefaultSettings.gutter),
          ],
        ),
      ),
    );
  }
}

class TxtObscureText extends StatefulWidget {
  final TextEditingController txtController;
  final Function validatorFunction;
  final String txtLabel;
  final bool isObscure;
  final bool isEnable;

  const TxtObscureText({
    super.key,
    required this.txtController,
    required this.validatorFunction,
    required this.txtLabel,
    this.isObscure = true,
    this.isEnable = true,
  });

  @override
  State<TxtObscureText> createState() => _TxtObscureTextState();
}

class _TxtObscureTextState extends State<TxtObscureText> {
  bool obscure = false;

  void toggleObscure() => setState(() => obscure = !obscure);

  @override
  void initState() {
    super.initState();
    obscure = widget.isObscure;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.txtController,
      enabled: widget.isEnable,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: widget.txtLabel,
        suffixIcon: InkWell(
          onTap: toggleObscure,
          child: Icon(
            obscure ? Icons.visibility_off : Icons.visibility,
          ),
        ),
      ),
      validator: (value) => widget.validatorFunction(value),
    );
  }
}
