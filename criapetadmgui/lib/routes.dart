import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'pages/home/home_page.dart';
import 'pages/login/login_page.dart';
import 'pages/user/register_page.dart';
import 'pages/user/user_page.dart';
import 'providers/auth_provider.dart';

const publicRoutes = [
  '/login',
  '/users/register',
];

class MinhaRotas {
  BuildContext context;
  MinhaRotas({required this.context});

  GoRouter get routes {
    return GoRouter(
      refreshListenable: Provider.of<AuthProvider>(context),
      redirect: (BuildContext context, GoRouterState state) {
        final authP = Provider.of<AuthProvider>(context, listen: false);
        final isAuthenticated = authP.token.isNotEmpty;
        final isLoginRoute = state.fullPath == '/login';

        if (!isAuthenticated) {
          return (isLoginRoute || publicRoutes.contains(state.fullPath))
              ? null
              : '/login';
        }

        if (isLoginRoute) return '/';

        return null;
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) {
            return const HomePage();
          },
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/users',
          builder: (context, state) {
            return const UserPage();
          },
        ),
        GoRoute(
          path: '/users/register',
          pageBuilder: (context, state) => const MaterialPage(
            child: RegisterPage(),
            fullscreenDialog: true,
          ),
        ),
      ],
    );
  }
}
