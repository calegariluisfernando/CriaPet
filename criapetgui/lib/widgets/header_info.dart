import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../my_default_settings.dart';
import '../notifiers/user_notifier.dart';

class HeaderInfo extends StatelessWidget {
  final VoidCallback? onTapInfo;
  final VoidCallback? onTapNotifications;

  const HeaderInfo({super.key, this.onTapInfo, this.onTapNotifications});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  MyDefaultSettings.gutter / 4,
                ),
              ),
              padding: EdgeInsets.all(MyDefaultSettings.gutter / 4),
              child: Icon(
                Icons.pets,
                color: MyDefaultSettings.logoColor,
              ),
            ),
            SizedBox(width: MyDefaultSettings.gutter / 4),
            UserInfo(onTap: onTapInfo),
          ],
        ),
        Icon(
          Icons.notifications,
          color: Colors.white,
        ),
      ],
    );
  }
}

class UserInfo extends StatelessWidget {
  final VoidCallback? onTap;

  const UserInfo({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserNotifier>(
      builder: (context, userNotifier, child) {
        String userText = userNotifier.user.apelido != null
            ? 'Olá, ${userNotifier.user.apelido}!'
            : 'Olá';

        return InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userText,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: MyDefaultSettings.gutter,
                  color: Colors.white,
                ),
              ),
              Row(
                children: [
                  Text(
                    'Minha Conta',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: MyDefaultSettings.gutter / 1.5,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Icon(
                    Icons.expand_more,
                    color: Colors.white,
                    size: 14,
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
