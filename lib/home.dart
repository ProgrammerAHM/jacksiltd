import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:jacksiltd/screens/add_product.dart';
import 'package:jacksiltd/screens/default_screen.dart';
import 'package:jacksiltd/screens/home_screen.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var currentIndex = 0;
  List screensList = [
    const HomeScreen(),
    const AddProductPage(),
    const DefaultScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: screensList[currentIndex],
      bottomNavigationBar: true
          ? null
          : SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: DotNavigationBar(
                  marginR: const EdgeInsets.symmetric(horizontal: 15),
                  backgroundColor: Colors.black,
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  currentIndex: currentIndex,
                  dotIndicatorColor: Colors.transparent,
                  unselectedItemColor: Colors.grey,
                  onTap: (index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  items: [
                    DotNavigationBarItem(
                      icon: const Icon(Icons.home_rounded),
                      selectedColor: Colors.white,
                    ),
                    DotNavigationBarItem(
                      icon: const Icon(Icons.add_circle_outline_sharp),
                      selectedColor: Colors.white,
                    ),
                    DotNavigationBarItem(
                      icon: const Icon(Icons.favorite_border_rounded),
                      selectedColor: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
