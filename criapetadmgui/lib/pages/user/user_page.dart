import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../contranints.dart';
import '../../entities/user.dart';
import '../../services/vml_http_service.dart';
import '../../widgets/main_menu/list_menu.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MenuDrawer(),
      appBar: AppBar(title: const Text('Users')),
      body: Container(
        margin: const EdgeInsets.all(defaultSpacing),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(defaultSpacing),
        ),
        child: UserTableList(),
      ),
    );
  }
}

class UserTableList extends StatefulWidget {
  const UserTableList({super.key});

  @override
  State<UserTableList> createState() => _UserTableListState();
}

class _UserTableListState extends State<UserTableList> {
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    _getUsersList();
  }

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder(borderRadius: BorderRadius.circular(defaultSpacing)),
      children: users.isNotEmpty ? _buildTable() : [_buildHeader()],
    );
  }

  _buildTable() {
    List<TableRow> trs = [_buildHeader()];
    for (User user in users) {
      trs.add(_buildRow(user: user));
    }

    return trs;
  }

  _getUsersList() async {
    VMLHttpService service = VMLHttpService.instance;
    try {
      Response response = await service.dio.get('/users');
      for (var element in response.data) {
        users.add(User.fromJson(element));
      }

      setState(() {});
    } on DioException catch (e) {
      String errorMessage = "Ops! Erro inesperado";

      if (e.response != null) {
        errorMessage = e.response?.data['message'];
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: redColor,
        ),
      );
    }
  }

  TableRow _buildHeader() {
    return const TableRow(
      children: [
        Center(child: Text('Photo')),
        Center(child: Text('Name')),
        Center(child: Text('Email')),
        Center(child: Text('Created At')),
        Center(child: Text('Id')),
      ],
    );
  }

  TableRow _buildRow({User? user}) {
    if (user == null) {
      return const TableRow(children: [Text('Nenhum elemento econtrado')]);
    }
    return TableRow(
      children: [
        Text('Teste'),
        Text(user.name),
        Text(user.email),
        Text('Data Cadastro'),
        Text("${user.id}"),
      ],
    );
  }
}
