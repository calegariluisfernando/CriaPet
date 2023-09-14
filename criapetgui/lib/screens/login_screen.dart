import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petguardgui/screens/home_screen.dart';
import 'package:provider/provider.dart';

import '../my_default_settings.dart';
import '../notifiers/user_notifier.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool passwordIsVisible = false;
  void togglePasswordVisibility() =>
      setState(() => passwordIsVisible = !passwordIsVisible);

  String serverSideErrorMsg = '';
  setServerSideErrorMsg({required String message}) =>
      setState(() => serverSideErrorMsg = message);

  bool isLoading = false;
  toggleIsLoading() => setState(() => isLoading = !isLoading);

  @override
  Widget build(BuildContext context) {
    final UserNotifier userNotifier = Provider.of<UserNotifier>(context);
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(MyDefaultSettings.gutter),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: MyDefaultSettings.gutter),
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(
                              MyDefaultSettings.gutter / 2),
                          decoration: const BoxDecoration(
                            color: MyDefaultSettings.logoColor,
                            borderRadius: BorderRadius.only(
                              topLeft:
                                  Radius.circular(MyDefaultSettings.gutter),
                              bottomRight:
                                  Radius.circular(MyDefaultSettings.gutter),
                            ),
                          ),
                          child: const Icon(
                            Icons.pets,
                            color: Colors.white,
                            size: 70,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Cria',
                              style: TextStyle(
                                fontFamily: GoogleFonts.cormorant().fontFamily,
                                fontSize: 50,
                                color: MyDefaultSettings.logoColor,
                              ),
                            ),
                            Text(
                              'Pet',
                              style: TextStyle(
                                fontFamily: GoogleFonts.cormorant().fontFamily,
                                fontSize: 50,
                                color: MyDefaultSettings.logoColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: MyDefaultSettings.gutter),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'E-mail',
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'O campo e-mail é obrigatório';
                        }
                        return null;
                      },
                      enabled: !isLoading,
                      onChanged: (value) => userNotifier.user.email = value,
                    ),
                    const SizedBox(height: MyDefaultSettings.gutter),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: InkWell(
                          onTap: togglePasswordVisibility,
                          child: Icon(
                            passwordIsVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                      ),
                      enabled: !isLoading,
                      obscureText: !passwordIsVisible,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'O campo senha é obrigatório';
                        }
                        return null;
                      },
                      onChanged: (value) => userNotifier.user.password = value,
                    ),
                    const SizedBox(height: MyDefaultSettings.gutter * 2),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MyDefaultSettings.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            MyDefaultSettings.gutter / 4,
                          ),
                        ),
                      ),
                      onPressed: isLoading
                          ? null
                          : () async {
                              toggleIsLoading();
                              if (_formKey.currentState!.validate()) {
                                bool successLogin = true;
                                await userNotifier.login((String message) {
                                  setServerSideErrorMsg(message: message);
                                  successLogin = false;
                                });

                                if (successLogin) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomeScreen(),
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
                              toggleIsLoading();
                            },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Entrar',
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(width: MyDefaultSettings.gutter / 4),
                          Icon(
                            Icons.login,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: MyDefaultSettings.gutter),
                    TextButton(
                      onPressed: isLoading ? null : () {},
                      child: const Text('Não tem uma conta? Registre-se'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}