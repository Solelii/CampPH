import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:campph/services/camp_service.dart';
import 'package:campph/services/user_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isPublic = true;

  Map<String, bool> selectableButtons = {
    'River': false,
    'Beach': false,
    'Lake': false,
    'Mountain': false,
    'Woods': false,
    'Glamping': false,
  };

  List<Camp> camps = [];
  bool isLoading = true;
  String? username;

  final CampFirestoreService campService = CampFirestoreService();

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadCamps();
  }

  Future<void> _loadUserData() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final fetchedUsername = await UserFirestoreService().getUsername(
        currentUser.uid,
      );
      if (!mounted) return;
      setState(() {
        username = fetchedUsername ?? 'User';
      });
    }
  }

  Future<void> _loadCamps() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      return;
    }

    final fetchedCamps = await campService.getCampsOwnedOrBookmarked(
      currentUser.uid,
    );

    if (!mounted) return;
    setState(() {
      camps = fetchedCamps;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedTags =
        selectableButtons.entries
            .where((entry) => entry.value)
            .map((entry) => entry.key)
            .toSet();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Profile"),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.green[300],
                  child: Text(
                    username != null && username!.isNotEmpty
                        ? username![0].toUpperCase()
                        : '',
                    style: const TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  username ?? 'Loading...',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Album Section
            const Text(
              "Album",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
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
                const SizedBox(width: 8),
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
                      const SizedBox(height: 8),
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
            const SizedBox(height: 10),

            // My Campgrounds Section
            const Text(
              "My Campgrounds",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Filter Controls
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // Public Button
                  _buildToggleButton("Public", isPublic, () {
                    setState(() => isPublic = true);
                  }, activeColor: const Color(0xFF3B862D)),

                  const SizedBox(width: 10),

                  // Private Button
                  _buildToggleButton("Private", !isPublic, () {
                    setState(() => isPublic = false);
                  }, activeColor: const Color(0xFFEFAD42)),

                  const SizedBox(width: 15),
                  Container(width: 1.5, height: 30, color: Colors.grey[700]),
                  const SizedBox(width: 10),

                  // Feature Tags
                  ...selectableButtons.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _buildTagButton(entry.key, entry.value, () {
                        setState(
                          () => selectableButtons[entry.key] = !entry.value,
                        );
                      }),
                    );
                  }).toList(),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Camp List
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : camps.isEmpty
                ? const Center(child: Text('No camps found.'))
                : Column(
                  children:
                      camps
                          .where((camp) {
                            if (isPublic && camp.campType != 'Public')
                              return false;
                            if (!isPublic && camp.campType != 'Private')
                              return false;
                            if (selectedTags.isNotEmpty &&
                                !camp.features.any(
                                  (f) => selectedTags.contains(f),
                                )) {
                              return false;
                            }
                            return true;
                          })
                          .map((camp) {
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              child: ListTile(
                                title: Text(
                                  camp.name,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      camp.description,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Owner: ${camp.ownerUsername ?? 'Unknown'}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Type: ${camp.campType}',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      'Features: ${camp.features.join(', ')}',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing:
                                    camp.bookmarked
                                        ? const Icon(
                                          Icons.bookmark,
                                          color: Colors.green,
                                        )
                                        : null,
                              ),
                            );
                          })
                          .toList(),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton(
    String label,
    bool isActive,
    VoidCallback onTap, {
    required Color activeColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? activeColor : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildTagButton(String tag, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF3B862D) : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        child: Text(
          tag,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
