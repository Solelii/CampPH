import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewFirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Adds or updates a review for a camp by a specific user
  Future<void> addOrUpdateReview({
    required String campId,
    required String userId,
    required String username,
    required int rating,
    required String comment,
  }) async {
    final query =
        await _db
            .collection('reviews')
            .where('campId', isEqualTo: campId)
            .where('userId', isEqualTo: userId)
            .limit(1)
            .get();

    final data = {
      'campId': campId,
      'userId': userId,
      'username': username,
      'rating': rating,
      'comment': comment,
      'dateCreated': FieldValue.serverTimestamp(),
    };

    if (query.docs.isNotEmpty) {
      // Update existing review
      await _db.collection('reviews').doc(query.docs.first.id).update(data);
    } else {
      // Add new review
      await _db.collection('reviews').add(data);
    }
  }

  /// Deletes a user's review for a specific camp
  Future<void> deleteReview({
    required String campId,
    required String userId,
  }) async {
    final query =
        await _db
            .collection('reviews')
            .where('campId', isEqualTo: campId)
            .where('userId', isEqualTo: userId)
            .limit(1)
            .get();

    if (query.docs.isNotEmpty) {
      await _db.collection('reviews').doc(query.docs.first.id).delete();
    }
  }

  /// Fetches all reviews for a given camp
  Future<List<Map<String, dynamic>>> getReviewsForCamp(String campId) async {
    // First, check if any reviews exist for the camp (without ordering)
    final initialSnapshot =
        await _db
            .collection('reviews')
            .where('campId', isEqualTo: campId)
            .get();

    if (initialSnapshot.docs.isEmpty) {
      // No reviews found, return empty list
      return [];
    }

    // Reviews exist, fetch them ordered by dateCreated descending
    final querySnapshot =
        await _db
            .collection('reviews')
            .where('campId', isEqualTo: campId)
            // .orderBy('dateCreated', descending: true)
            .get();

    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  /// Calculates the average rating for a camp
  Future<double> calculateAverageRating(String campId) async {
    final querySnapshot =
        await _db
            .collection('reviews')
            .where('campId', isEqualTo: campId)
            .get();

    if (querySnapshot.docs.isEmpty) return 0.0;

    final totalRating = querySnapshot.docs.fold<int>(
      0,
      (sum, doc) => sum + (doc.data()['rating'] as int),
    );

    return totalRating / querySnapshot.docs.length;
  }
}
