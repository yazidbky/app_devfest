import 'package:app_devfest/on%20boarding/Registre/registreScreen.dart';
import 'package:app_devfest/login/loginScreen.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<Home> {
  int selectedIndex = 0;
  static List<Widget> options = [
    LoginScreen(),
    RegistreScreen(),
    const Placeholder(
      color: Colors.green,
    ),
    const Placeholder(
      color: Colors.grey,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: options.elementAt(selectedIndex)),
      bottomNavigationBar: SafeArea(
          child: Container(
              height: MediaQuery.of(context).size.height * 0.1,
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: Icon(Icons.home,
                        color: selectedIndex == 0 ? Colors.pink : Colors.grey,
                        size: 30),
                    onPressed: () {
                      setState(() {
                        selectedIndex = 0;
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.sports_soccer,
                        color: selectedIndex == 1 ? Colors.pink : Colors.grey,
                        size: 30),
                    onPressed: () {
                      setState(() {
                        selectedIndex = 1;
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.star,
                        color: selectedIndex == 2 ? Colors.pink : Colors.grey,
                        size: 30),
                    onPressed: () {
                      setState(() {
                        selectedIndex = 2;
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.person,
                      color: selectedIndex == 3 ? Colors.pink : Colors.grey,
                      size: 30,
                    ),
                    onPressed: () {
                      setState(() {
                        selectedIndex = 3;
                      });
                    },
                  ),
                ],
              ))),
    );
  }
}
