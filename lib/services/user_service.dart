import 'package:cloud_firestore/cloud_firestore.dart';

class UserFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveUserData({
    required String uid,
    required String email,
    required String username,
  }) async {
    final DateTime now = DateTime.now();

    try {
      await _firestore.collection('users').doc(uid).set({
        'email': email,
        'username': username,
        'DateCreated': now,
      });
    } catch (e) {
      print('Error saving user data: $e');
      rethrow;
    }
  }

  Future<String?> getUsername(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        return data['username'] as String?;
      } else {
        return null;
      }
    } catch (e) {
      print('Error retrieving username: $e');
      return null;
    }
  }
}
