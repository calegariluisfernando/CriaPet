import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(context.read<UserProvider>().user.name),
            const SizedBox(height: 10),
            const Text('Users'),
            IconButton(
              onPressed: () => GoRouter.of(context).go('/users'),
              icon: const Icon(Icons.person),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                context.read<AuthProvider>().unregisterToken();
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Sair'),
                  SizedBox(width: 10),
                  Icon(Icons.logout),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
