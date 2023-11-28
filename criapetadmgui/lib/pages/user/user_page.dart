import 'package:criapet_adm/contranints.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: defaultSpacing),
        child: Row(
          children: [
            const Text('User Page'),
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
