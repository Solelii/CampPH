import 'package:campph/screens/explore_screen.dart';
import 'package:campph/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:campph/themes/app_colors.dart';

class NavigationWidget extends StatefulWidget {
  const NavigationWidget({super.key});

  @override
  State<NavigationWidget> createState() => _NavigationWidget();
}

class _NavigationWidget extends State<NavigationWidget> {
  int index = 0;
  final screens = [ExploreScreen(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index],
      backgroundColor: AppColors.white,
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
