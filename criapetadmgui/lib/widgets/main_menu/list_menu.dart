import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';
import 'item_menu.dart';

class MenuDrawer extends StatefulWidget {
  const MenuDrawer({super.key});

  @override
  State<MenuDrawer> createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      // shape: const RoundedRectangleBorder(),
      child: ListView(
        children: [
          Consumer<UserProvider>(
            builder: (context, userProvider, child) => UserAccountsDrawerHeader(
              accountName: Text(userProvider.user.apelido),
              accountEmail: Text(userProvider.user.email),
              currentAccountPicture: const CircleAvatar(child: Text("SZ")),
            ),
          ),
          ItemMenu(
            title: 'Home',
            icon: const Icon(Icons.home),
            path: '/',
          ),
          ItemMenu(
            title: 'Users',
            icon: const Icon(Icons.person),
            path: '/users',
          ),
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) => ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () => authProvider.unregisterToken(),
            ),
          ),
        ],
      ),
    );
  }
}
