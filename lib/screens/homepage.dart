import 'package:flutter/material.dart';
import '../widgets/homepage_search.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int index = 0;
  final screens = [
    Center(child: SearchBarApp()),
    Center(child: Text('Saved')),
    Center(child: Text('Profile')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index],
      backgroundColor: Colors.white,
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(color: Colors.white),
          ),
        ),
        child: NavigationBar(
          backgroundColor: Color(0xFF234F1E),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          selectedIndex: index,
          onDestinationSelected: (index) => setState(() => this.index = index),
          destinations: const <Widget>[
            NavigationDestination(
              selectedIcon: Icon(Icons.explore, color: Color(0xFF234F1E)),
              icon: Icon(Icons.explore, color: Colors.grey),
              label: 'Explore',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.bookmark, color: Color(0xFF234F1E)),
              icon: Icon(Icons.bookmark_border, color: Colors.grey),
              label: 'Saved',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.person, color: Color(0xFF234F1E)),
              icon: Icon(Icons.person, color: Colors.grey),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
