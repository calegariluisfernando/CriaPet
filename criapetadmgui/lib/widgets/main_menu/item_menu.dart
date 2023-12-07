import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ItemMenu extends StatefulWidget {
  String title;
  String path;
  bool isActive;
  bool enabled;
  Icon? icon;

  ItemMenu({
    required this.title,
    required this.path,
    this.enabled = true,
    this.isActive = false,
    this.icon,
    super.key,
  });

  @override
  State<ItemMenu> createState() => _ItemMenuState();
}

class _ItemMenuState extends State<ItemMenu> {
  Future<void> triggerOnTap() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString('lastAccessRoute', widget.path);
      widget.isActive = !widget.isActive;
      GoRouter.of(context).go(widget.path);
    });
  }

  @override
  void initState() {
    super.initState();
    _checkIsActiveItem();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: widget.icon,
      title: Text(
        widget.title,
        style: TextStyle(
          fontWeight: widget.isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: triggerOnTap,
      enabled: widget.enabled,
    );
  }

  Future<void> _checkIsActiveItem() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lastAccessRoute = prefs.getString('lastAccessRoute') ?? '/';
    if (widget.path == lastAccessRoute) {
      setState(() => widget.isActive = true);
    }
  }
}
