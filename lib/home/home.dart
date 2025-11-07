import 'package:app_devfest/home/homePage.dart';
import 'package:app_devfest/home/notification/notification_screen.dart';
import 'package:app_devfest/sinistre/claim.dart';
import 'package:app_devfest/utils/mainColor.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<Home> {
  int selectedIndex = 0;

  static List<Widget> options = [
    const HomePage(),
    const AccidentDetailsSubmission(), // Updated: CameraPage is included here
    const NotificationScreen(),
  ];

  void _onItemTapped(int index) {
    if (index == 1) {
      // Navigate to the CameraPage screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => options[index], // Fetch CameraPage dynamically
        ),
      );
    } else {
      // Stay within the navigation bar
      setState(() {
        selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: options.elementAt(selectedIndex), // Fetch widget dynamically
      ),
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
                    color: selectedIndex == 0 ? mainColor : Colors.grey,
                    size: 30),
                onPressed: () => _onItemTapped(0),
              ),
              InkWell(
                  child: Image.asset(
                    'assets/images/add.png',
                  ),
                  onTap: () {
                    _onItemTapped(1);
                  }),
              IconButton(
                icon: Icon(Icons.notifications,
                    color: selectedIndex == 2 ? mainColor : Colors.grey,
                    size: 30),
                onPressed: () => _onItemTapped(2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
