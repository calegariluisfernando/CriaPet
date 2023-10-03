import 'package:flutter/material.dart';
import 'package:petguardgui/screens/animal_screen.dart';

import '../my_default_settings.dart';
import '../widgets/header_info.dart';
import 'user_info_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final color = [
    Colors.red,
    Colors.amber,
    Colors.teal,
    Colors.blueGrey,
    Colors.blue,
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: MyDefaultSettings.primaryColor,
          automaticallyImplyLeading: false,
          title: HeaderInfo(
            onTapInfo: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UserInfoScreen()),
            ),
          ),
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
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
                child: Padding(
                  padding: EdgeInsets.all(MyDefaultSettings.gutter),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 110,
                          width: MediaQuery.of(context).size.width,
                          child: PageView.builder(
                            itemCount: color.length,
                            padEnds: false,
                            pageSnapping: false,
                            physics: BouncingScrollPhysics(),
                            reverse: true,
                            controller: PageController(viewportFraction: 0.7),
                            itemBuilder: (context, index) {
                              return Container(
                                padding: EdgeInsets.only(
                                    right: MyDefaultSettings.gutter),
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  // color: color[index],
                                  color: Colors.transparent,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CarouselPets(),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: MyDefaultSettings.gutter),
                        CardInfoPet(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CarouselPets extends StatelessWidget {
  const CarouselPets({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(MyDefaultSettings.gutter / 4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            offset: Offset(5, 8),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: 92,
              maxHeight: 92,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(MyDefaultSettings.gutter / 4),
                bottomLeft: Radius.circular(MyDefaultSettings.gutter / 4),
              ),
              child: Image.network(
                '${MyDefaultSettings.baseUrl}/gato.png',
                alignment: Alignment.topLeft,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(MyDefaultSettings.gutter / 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pocker',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                Row(
                  children: [
                    Text(
                      'Dono: ',
                      style: TextStyle(fontSize: 10),
                    ),
                    Text(
                      'Maria Luiza',
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Raça: ',
                      style: TextStyle(fontSize: 10),
                    ),
                    Text(
                      'Rajado',
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Idade: ',
                      style: TextStyle(fontSize: 10),
                    ),
                    Text(
                      '2 anos',
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CardInfoPet extends StatelessWidget {
  const CardInfoPet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AnimalScreen(),
          ),
        ),
        child: Text('Info Pets'),
      ),
    );
  }
}
