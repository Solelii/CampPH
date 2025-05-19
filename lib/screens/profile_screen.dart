import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:campph/services/camp_service.dart';
import 'package:campph/services/user_service.dart'; // NEW: import user service

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
  String? username; // NEW: to store the username

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture and Username
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username ?? 'Loading...',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Camps List (Filtered by isPublic and selected tags)
            Expanded(
              child:
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : camps.isEmpty
                      ? const Center(child: Text('No camps found.'))
                      : ListView.builder(
                        itemCount: camps.length,
                        itemBuilder: (context, index) {
                          final camp = camps[index];

                          // Filter by Public/Private toggle
                          if (isPublic && camp.campType != 'Public') {
                            return Container();
                          }
                          if (!isPublic && camp.campType != 'Private') {
                            return Container();
                          }

                          // Filter by selected tags, if any selected
                          final selectedTags =
                              selectableButtons.entries
                                  .where((entry) => entry.value)
                                  .map((entry) => entry.key)
                                  .toSet();

                          if (selectedTags.isNotEmpty &&
                              !camp.features.any(
                                (feature) => selectedTags.contains(feature),
                              )) {
                            return Container();
                          }

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            child: ListTile(
                              title: Text(camp.name),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(camp.description),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Type: ${camp.campType}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Features: ${camp.features.join(', ')}',
                                    style: const TextStyle(color: Colors.grey),
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
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
