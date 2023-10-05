import 'package:flutter/material.dart';

import '../models/especie.dart';
import '../my_default_settings.dart';
import '../services/maria_service.dart';
import '../widgets/camera_preview.dart';
import '../widgets/header_info.dart';
import '../widgets/user_profile_photo.dart';
import 'user_info_screen.dart';

class AnimalScreen extends StatefulWidget {
  const AnimalScreen({super.key});

  @override
  State<AnimalScreen> createState() => _AnimalScreenState();
}

class _AnimalScreenState extends State<AnimalScreen> {
  final _formKey = GlobalKey<FormState>();
  List<Especie> especies = [];
  int? _dropdownValue;

  @override
  void initState() {
    super.initState();
    obterEspecies();
  }

  obterEspecies() async {
    MariaService ms = MariaService.instance;
    var response = await ms.dio.get('/especie');
    Map<String, dynamic> responseData = response.data;
    List<Especie> dataEspecies = [];

    responseData
        .forEach((key, value) => dataEspecies.add(Especie.fromMap(value)));

    setState(() {
      especies = dataEspecies;
      _dropdownValue = especies.first.id;
    });
  }

  void dropdownCallback(int? selectedValue) {
    if (selectedValue is int) {
      setState(() {
        _dropdownValue = selectedValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: MyDefaultSettings.primaryColor,
          title: HeaderInfo(
            onTapInfo: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const UserInfoScreen(),
              ),
            ),
          ),
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              HeaderPhoto(),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: MyDefaultSettings.gutter,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      DropdownButtonFormField<int>(
                        decoration: const InputDecoration(labelText: 'Espécie'),
                        value: _dropdownValue,
                        items: especies.isNotEmpty ? especies.map((Especie e) => DropdownMenuItem<int>(value: e.id, child: Text(e.name),)).toList() : null,
                        onChanged: dropdownCallback,
                        isExpanded: true,
                        validator: (value) {
                          if (value == null || value <= 0) {
                            return 'O campo espécie é obrigatório';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: MyDefaultSettings.gutter),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Nome'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'O campo nome é obrigatório';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: MyDefaultSettings.gutter),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Raça'),
                      ),
                      SizedBox(height: MyDefaultSettings.gutter),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Peso'),
                        keyboardType: TextInputType.numberWithOptions(
                            signed: true, decimal: true),
                      ),
                      SizedBox(height: MyDefaultSettings.gutter),
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Data Nascimento'),
                        keyboardType: TextInputType.datetime,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HeaderPhoto extends StatelessWidget {
  const HeaderPhoto({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            MyDefaultSettings.primaryColor,
            Colors.white,
          ],
          stops: [.5, .5],
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: MyDefaultSettings.gutter),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  UserProfilePhoto(
                    size: 100,
                  ),
                  InkWell(
                    onTap: () async {
                      String? filePath = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyCameraPreview(),
                        ),
                      );
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: MyDefaultSettings.primaryColor.withOpacity(.8),
                      ),
                      child: Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: MyDefaultSettings.gutter),
        ],
      ),
    );
  }
}
