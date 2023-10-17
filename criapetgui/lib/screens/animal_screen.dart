import 'package:flutter/material.dart';

import '../models/especie.dart';
import '../models/raca.dart';
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
  int _dropdownValueEspecie = 1;

  List<Raca> racas = [];
  int? _dropdownValueRacas;

  @override
  void initState() {
    super.initState();
    obterEspecies();
    obterRacas(_dropdownValueEspecie);
  }

  obterEspecies() async {
    MariaService ms = MariaService.instance;

    var response = await ms.dio.get('/especie');
    List<Especie> dataEspecies = [];
    response.data.forEach((element) => dataEspecies.add(Especie.fromMap(element)));
    setState(() {
      especies = dataEspecies;
      _dropdownValueEspecie = especies.first.id!;
    });
  }

  void dropdownCallbackEspecies(int? selectedValue) {
    if (selectedValue is int) {
      setState(() {
        _dropdownValueEspecie = selectedValue;
      });
    }

    obterRacas(_dropdownValueEspecie);
  }

  obterRacas(int especie) async {
    MariaService ms = MariaService.instance;

    var response = await ms.dio.get('/raca', queryParameters: {'especie_id': especie});
    List<Raca> dataRacas = [];
    response.data.forEach((element) => dataRacas.add(Raca.fromMap(element)));
    setState(() {
      racas = dataRacas;
      _dropdownValueRacas = racas.first.id;
    });
  }

  void dropdownCallbackRacas(int? selectedValue) {
    if (selectedValue is int) {
      setState(() {
        _dropdownValueRacas = selectedValue;
      });
    }
  }

  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      cancelText: 'Fechar',
      helpText: 'Data de Nascimento',
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  TextFormField buildDateOfBirthFormField() {
    return TextFormField(
      readOnly: true,
      onTap: () => _selectDate(context),
      decoration: const InputDecoration(
        labelText: 'Data Nascimento',
      ),
      controller: TextEditingController(
        text: _selectedDate == null ? '' : "${_selectedDate!.toLocal()}".split(' ')[0],
      ),
    );
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
                        value: _dropdownValueEspecie,
                        items: especies.isNotEmpty ? especies.map((Especie e) => DropdownMenuItem<int>(value: e.id, child: Text(e.name),)).toList() : null,
                        onChanged: dropdownCallbackEspecies,
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
                      DropdownButtonFormField<int>(
                        decoration: const InputDecoration(labelText: 'Raça'),
                        value: _dropdownValueRacas,
                        items: racas.isNotEmpty ? racas.map((Raca e) => DropdownMenuItem<int>(value: e.id, child: Text(e.name),)).toList() : null,
                        onChanged: dropdownCallbackRacas,
                        isExpanded: true,
                        validator: (value) {
                          if (value == null || value <= 0) {
                            return 'O campo raça é obrigatório';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: MyDefaultSettings.gutter),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Peso'),
                        keyboardType: TextInputType.numberWithOptions(
                          signed: true,
                          decimal: true,
                        ),
                      ),
                      SizedBox(height: MyDefaultSettings.gutter),
                      buildDateOfBirthFormField(),
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
