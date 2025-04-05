import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isPublic = true;

  Map<String, bool> selectableButtons = {
    "River": false,
    "Beach": false,
    "Mountain": false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Profile"),
        leading: IconButton(onPressed: () => {}, icon: Icon(Icons.arrow_back)),
        actions: [IconButton(onPressed: () => {}, icon: Icon(Icons.more_vert))],
      ),
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
                    height: 250,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        height: 122,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        height: 122,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(5),
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
              alignment: Alignment.center,
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
                // Public Button
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

                // Private Button
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
                SizedBox(width: 15),

                // Divider
                Container(width: 1.5, height: 30, color: Colors.grey[700]),

                SizedBox(width: 10),

                ...selectableButtons.keys.map((tag) {
                  return Padding(
                    padding: EdgeInsets.only(
                      right: 10,
                    ), // Spacing after each tag button
                    child: SizedBox(
                      width: 80, // Fixed width for all tag buttons
                      child: GestureDetector(
                        onTap:
                            () => setState(
                              () =>
                                  selectableButtons[tag] =
                                      !selectableButtons[tag]!,
                            ),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color:
                                selectableButtons[tag]!
                                    ? Color(0xFF3B862D)
                                    : Colors.grey[300],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            tag,
                            style: TextStyle(
                              color:
                                  selectableButtons[tag]!
                                      ? Colors.white
                                      : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
