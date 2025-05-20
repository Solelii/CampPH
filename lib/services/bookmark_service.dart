import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookmarkService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  /// Fetches the list of bookmarked camp IDs for the current user.
  Future<List<String>> getBookmarkedCampIds() async {
    if (_currentUser == null) return [];

    try {
      final doc =
          await _firestore.collection('bookmarks').doc(_currentUser!.uid).get();
      if (doc.exists) {
        final data = doc.data();
        if (data != null && data.containsKey('campIds')) {
          return List<String>.from(data['campIds']);
        }
      }
      return [];
    } catch (e) {
      print('Error fetching bookmarked camps: $e');
      return [];
    }
  }

  /// Checks if a camp ID is bookmarked by the current user.
  Future<bool> isCampBookmarked(String campId) async {
    final bookmarkedIds = await getBookmarkedCampIds();
    return bookmarkedIds.contains(campId);
  }

  /// Adds a camp ID to the user's bookmarks.
  Future<void> addBookmark(String campId) async {
    if (_currentUser == null) return;

    final docRef = _firestore.collection('bookmarks').doc(_currentUser!.uid);

    try {
      final doc = await docRef.get();

      if (doc.exists) {
        await docRef.update({
          'campIds': FieldValue.arrayUnion([campId]),
        });
      } else {
        await docRef.set({
          'userId': _currentUser!.uid,
          'username': _currentUser!.displayName ?? '',
          'campIds': [campId],
          'dateCreated': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error adding bookmark: $e');
      rethrow;
    }
  }

  /// Removes a camp ID from the user's bookmarks.
  Future<void> removeBookmark(String campId) async {
    if (_currentUser == null) return;

    final docRef = _firestore.collection('bookmarks').doc(_currentUser!.uid);

    try {
      await docRef.update({
        'campIds': FieldValue.arrayRemove([campId]),
      });
    } catch (e) {
      print('Error removing bookmark: $e');
      rethrow;
    }
  }

  /// Toggles the bookmark status for a camp ID.
  Future<void> toggleBookmark(String campId) async {
    final isBookmarked = await isCampBookmarked(campId);
    if (isBookmarked) {
      await removeBookmark(campId);
    } else {
      await addBookmark(campId);
    }
  }
}
