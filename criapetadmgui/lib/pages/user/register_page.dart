import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../contranints.dart';
import '../../services/vml_http_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: defaultSpacing,
                  ),
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
                  'Junte-se a nós hoje',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: defaultSpacing / 2),
                Text(
                  'Digite seu e-mail e senha para se cadastrar',
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
  final TextEditingController _nameContoller = TextEditingController();
  final TextEditingController _emailContoller = TextEditingController();
  final TextEditingController _passwordContoller = TextEditingController();
  bool _termCondition = false;
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
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

                // Nome
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Nome'),
                  keyboardType: TextInputType.text,
                  controller: _nameContoller,
                  validator: (value) => value == null || value.isEmpty
                      ? 'O campo nome é obrigatório'
                      : null,
                ),
                const SizedBox(height: defaultSpacing),

                // Email
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailContoller,
                  validator: (value) => value == null || value.isEmpty
                      ? 'O campo email é obrigatório'
                      : null,
                ),
                const SizedBox(height: defaultSpacing),

                // Senha
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Senha',
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
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: !_isVisible,
                  controller: _passwordContoller,
                  validator: (value) => value == null || value.isEmpty
                      ? 'O campo senha é obrigatório'
                      : null,
                ),
                const SizedBox(height: defaultSpacing),

                // Termos
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: _termCondition,
                      fillColor: MaterialStateProperty.resolveWith(
                        (states) => !_termCondition ? Colors.white : blueColor,
                      ),
                      onChanged: (value) => setState(
                        () => _termCondition = !_termCondition,
                      ),
                    ),
                    const Text(
                      'Eu concordo com os ',
                      style: TextStyle(fontSize: 14),
                    ),
                    const Text(
                      'Termos e condições',
                      style: TextStyle(
                        color: blueColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: defaultSpacing),

                // Gravar
                InkWell(
                  onTap: () async {
                    String mensagemErro = "Ops! Algo deu errado.";
                    bool isValid = false;

                    if (_formKey.currentState!.validate()) {
                      if (!_termCondition) {
                        mensagemErro = "Aceite os termos para continuar.";
                      } else {
                        VMLHttpService service = VMLHttpService.instance;

                        try {
                          await service.dio.post(
                            '/users',
                            data: {
                              "name": _nameContoller.text,
                              "email": _emailContoller.text,
                              "password": _passwordContoller.text,
                            },
                          );
                          isValid = true;
                        } on DioException catch (e) {
                          if (e.response != null) {
                            mensagemErro = e.response?.data['message'];
                          }
                        }
                      }

                      if (!isValid) {
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
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Usuário cadastrado com sucesso!',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );

                        GoRouter.of(context).go('/login');
                      }
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: (defaultSpacing / 1.2),
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
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Registrar',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: defaultSpacing),

                // Registrar-se
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Já tem uma conta?'),
                    const SizedBox(width: 5),
                    InkWell(
                      onTap: () {
                        context.go('/login');
                      },
                      child: const Text(
                        'Entrar',
                        style: TextStyle(
                          color: defaultFucusedBorderColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: defaultSpacing),
                const SizedBox(height: defaultSpacing * 2),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
