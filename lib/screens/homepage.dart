import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int index = 0;
  final screens = [
    Center(child: Text('Explore')),
    Center(child: Text('Saved')),
    ProfilePage(),
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

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isPublic = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture and Name
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.green[300],
                  child: Text(
                    "K",
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Khurt Dilanco",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),

            // Album Section
            Text(
              "Album",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Image Layout
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        height: 38,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      SizedBox(height: 4),
                      Container(
                        height: 38,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),

            // View All Button
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: Text(
                  "View All",
                  style: TextStyle(color: Colors.green[700]),
                ),
              ),
            ),

            // My Campgrounds Section
            SizedBox(height: 10),
            Text(
              "My Campgrounds",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Toggle button for Public / Private
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isPublic = true;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isPublic ? Color(0xFF3B862D) : Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Public",
                      style: TextStyle(
                        color: isPublic ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isPublic = false;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isPublic ? Colors.grey[300] : Color(0xFFEFAD42),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Private",
                      style: TextStyle(
                        color: isPublic ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
