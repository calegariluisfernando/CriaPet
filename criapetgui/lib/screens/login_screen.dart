import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../my_default_settings.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final Key _formKey = GlobalKey<FormState>();

  bool passwordIsVisible = false;
  void togglePasswordVisibility() =>
      setState(() => passwordIsVisible = !passwordIsVisible);

  @override
  Widget build(BuildContext context) {
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
                    const SizedBox(height: MyDefaultSettings.gutter),
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
                      controller: emailController,
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
                    ),
                    const SizedBox(height: MyDefaultSettings.gutter),
                    TextFormField(
                      controller: passwordController,
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
                      obscureText: !passwordIsVisible,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'O campo senha é obrigatório';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: MyDefaultSettings.gutter * 2),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Entrar'),
                    ),
                    const SizedBox(height: MyDefaultSettings.gutter),
                    TextButton(
                      onPressed: () {},
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
