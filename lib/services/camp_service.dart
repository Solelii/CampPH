import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';

class Camp {
  final String id;
  final String name;
  final String description;
  final String? campType;
  final List<String> features;
  final GeoPoint location;
  final bool bookmarked;
  final String ownerUsername; // <-- Added this

  Camp({
    required this.id,
    required this.name,
    required this.description,
    required this.campType,
    required this.features,
    required this.location,
    required this.bookmarked,
    required this.ownerUsername, // <-- Added this
  });

  factory Camp.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Camp(
      id: doc.id,
      name: data['CampName'] ?? '',
      description: data['CampDescription'] ?? '',
      campType: data['CampType'],
      features: List<String>.from(data['CampFeatures'] ?? []),
      location: data['location'],
      bookmarked: data['bookmarked'] ?? false,
      ownerUsername: data['ownerUsername'] ?? 'Unknown', // <-- Added this
    );
  }
}

class CampFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveCampData({
    required LatLng location,
    required String name,
    required String description,
    required Set<String> tags,
    required String ownerId,
    required String ownerUsername,
  }) async {
    final DateTime now = DateTime.now();

    final String? campType =
        tags.contains('Public')
            ? 'Public'
            : tags.contains('Private')
            ? 'Private'
            : null;

    final List<String> features =
        tags.where((tag) => tag != 'Public' && tag != 'Private').toList();

    try {
      await _firestore.collection('camps').add({
        'location': GeoPoint(location.latitude, location.longitude),
        'DateCreated': now,
        'CampType': campType,
        'CampFeatures': features,
        'CampName': name,
        'CampDescription': description,
        'ownerId': ownerId,
        'ownerUsername': ownerUsername,
        'bookmarked': false,
      });
    } catch (e) {
      print('Error saving camp data: $e');
      rethrow;
    }
  }

  Future<List<Camp>> getCampsOwnedOrBookmarked(String currentUserId) async {
    try {
      final ownerQuery =
          await _firestore
              .collection('camps')
              .where('ownerId', isEqualTo: currentUserId)
              .get();

      final bookmarkedQuery =
          await _firestore
              .collection('camps')
              .where('bookmarked', isEqualTo: true)
              .get();

      final allDocs = {...ownerQuery.docs, ...bookmarkedQuery.docs};

      return allDocs.map((doc) => Camp.fromDoc(doc)).toList();
    } catch (e) {
      print('Error fetching camps: $e');
      return [];
    }
  }
}
