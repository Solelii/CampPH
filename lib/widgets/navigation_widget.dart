import 'package:campph/screens/explore_screen.dart';
import 'package:campph/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:campph/themes/app_colors.dart';

class NavigationWidget extends StatefulWidget {
  final Map<String, dynamic>? campToOpen;

  const NavigationWidget({super.key, this.campToOpen});

  @override
  State<NavigationWidget> createState() => _NavigationWidgetState();
}

class _NavigationWidgetState extends State<NavigationWidget> {
  int index = 0;

  @override
  void initState() {
    super.initState();
    if (widget.campToOpen != null) {
      index = 0; // Open Explore tab
    }
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      ExploreScreen(campToOpen: widget.campToOpen),
      ProfilePage(),
    ];

    return Scaffold(
      backgroundColor: AppColors.white,
      body: screens[index],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(color: Colors.white),
          ),
        ),
        child: NavigationBar(
          backgroundColor: const Color(0xFF234F1E),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          selectedIndex: index,
          onDestinationSelected: (selectedIndex) {
            setState(() {
              index = selectedIndex;
            });
          },
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
