import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../contranints.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';

const double defaultMaxWidth = 540.0;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: defaultSpacing),
                padding: const EdgeInsets.all(defaultSpacing),
                constraints: const BoxConstraints(maxWidth: 540),
                child: const Stack(
                  children: [
                    MainLogin(),
                    HeaderLogin(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HeaderLogin extends StatelessWidget {
  const HeaderLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: defaultSpacing,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: defaultSpacing,
        ),
        decoration: const BoxDecoration(
          color: Color(0xfff7fafc),
          borderRadius: BorderRadius.all(
            Radius.circular(defaultSpacing / 2),
          ),
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFF49A3F1),
              Color(0xFF1A73E8),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.14),
              offset: Offset(0, 0.25),
              blurRadius: 1.25,
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Color.fromRGBO(0, 187, 212, 0.4),
              offset: Offset(0, 0.4375),
              blurRadius: 0.625,
              spreadRadius: -0.3125,
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                SizedBox(height: defaultSpacing * 2),
                Text(
                  'Sistema',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: defaultSpacing / 2),
                Text(
                  'Bemvindo de volta',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: defaultSpacing * 2),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MainLogin extends StatefulWidget {
  const MainLogin({super.key});

  @override
  State<MainLogin> createState() => _MainLoginState();
}

class _MainLoginState extends State<MainLogin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _rememberMe = true;

  bool _isVisible = false;

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(
      context,
      listen: false,
    );
    final AuthProvider authProvider = Provider.of<AuthProvider>(
      context,
      listen: false,
    );

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: defaultSpacing * 2),
          margin: const EdgeInsets.only(top: defaultSpacing),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(defaultSpacing / 2)),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.1),
                offset: Offset(0, 0.25),
                blurRadius: 0.375,
                spreadRadius: -0.0625,
              ),
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.06),
                offset: Offset(0, 0.125),
                blurRadius: 0.25,
                spreadRadius: -0.0625,
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: defaultSpacing * 10),
                Container(
                  constraints: const BoxConstraints(minHeight: 1.0),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.white,
                        defaultBorderColor,
                        Colors.white,
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: defaultSpacing * 3),

                // Email
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined, color: Colors.black),
                  ),
                  enabled: !_isLoading,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => value == null || value.isEmpty
                      ? 'O campo e-mail é obrigatório'
                      : null,
                  controller: _emailController,
                  onChanged: (String value) =>
                      userProvider.user.email = value.trim(),
                ),
                const SizedBox(height: defaultSpacing),

                // Senha
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    prefixIcon: const Icon(
                      Icons.lock_outlined,
                      color: Colors.black,
                    ),
                    suffixIcon: InkWell(
                      onTap: () => setState(() => _isVisible = !_isVisible),
                      child: Icon(
                        _isVisible
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  enabled: !_isLoading,
                  obscureText: !_isVisible,
                  keyboardType: TextInputType.text,
                  validator: (value) => value == null || value.isEmpty
                      ? 'O campo senha é obrigatório'
                      : null,
                  controller: _passwordController,
                  onChanged: (String value) =>
                      userProvider.user.password = value,
                ),
                const SizedBox(height: defaultSpacing),

                // Remember me
                Row(
                  children: [
                    Switch.adaptive(
                      activeColor: Colors.white,
                      activeTrackColor: _isLoading ? Colors.grey : Colors.black,
                      inactiveTrackColor: Colors.grey,
                      inactiveThumbColor: Colors.white,
                      value: _rememberMe,
                      onChanged: _isLoading
                          ? null
                          : (value) => setState(() => _rememberMe = value),
                    ),
                    const SizedBox(width: defaultSpacing / 2),
                    const Text('Lembrar me'),
                  ],
                ),
                const SizedBox(height: defaultSpacing * 2),

                // Entrar
                InkWell(
                  onTap: _isLoading
                      ? null
                      : () async {
                          setState(() => _isLoading = !_isLoading);
                          String mensagemErro = "Ops! Algo deu errado.";
                          bool isValid = false;
                          Map<String, dynamic> login = {'token': ''};

                          if (_formKey.currentState!.validate()) {
                            login = await userProvider.login();
                            if (login.containsKey('error') &&
                                login['error'] > 0) {
                              mensagemErro = login['message'];
                            } else {
                              isValid = true;
                            }
                          }

                          if (isValid) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Entrando...",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );

                            authProvider.registerToken(login['token']);
                            GoRouter.of(context).go('/');
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  mensagemErro,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                backgroundColor: redColor,
                              ),
                            );
                          }

                          setState(() => _isLoading = !_isLoading);
                        },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: (defaultSpacing / 1.2),
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xfff7fafc),
                      borderRadius: BorderRadius.all(
                        Radius.circular(defaultSpacing / 2),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: !_isLoading
                            ? [
                                const Color(0xFF49A3F1),
                                const Color(0xFF1A73E8),
                              ]
                            : [
                                const Color.fromRGBO(167, 169, 171, 1),
                                inactiveTextColor,
                              ],
                      ),
                    ),
                    child: Stack(
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Entrar',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        if (_isLoading)
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: defaultSpacing),
                                child: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator.adaptive(
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: defaultSpacing * 2),

                // Cadastre-se
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Não tem uma conta?'),
                    const SizedBox(width: 5),
                    InkWell(
                      onTap: _isLoading
                          ? null
                          : () => context.go('/users/register'),
                      child: Text(
                        'Cadastre-se',
                        style: TextStyle(
                          color: _isLoading
                              ? const Color.fromARGB(255, 123, 124, 124)
                              : defaultFucusedBorderColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: defaultSpacing * 2),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
