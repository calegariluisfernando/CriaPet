import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('UserPage'),
            IconButton(
              onPressed: () => GoRouter.of(context).go('/'),
              icon: const Icon(Icons.home),
            ),
          ],
        ),
      ),
    );
  }
}
