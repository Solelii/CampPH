import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';

class Camp {
  final String id;
  final String name;
  final String description;
  final String? campType;
  final List<String> features;
  final GeoPoint location;
  final String ownerUsername;
  final String? ownerId; // Added ownerId field because toMap uses it

  Camp({
    required this.id,
    required this.name,
    required this.description,
    required this.campType,
    required this.features,
    required this.location,
    required this.ownerUsername,
    this.ownerId,
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
      ownerUsername: data['ownerUsername'] ?? 'Unknown',
      ownerId: data['ownerId'],
    );
  }
}

class CampFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> getAllCamps() {
    return _firestore
        .collection('camps')
        .orderBy('DateCreated', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            final GeoPoint geoPoint = data['location'] as GeoPoint;
            return {
              'id': doc.id,
              ...data,
              'location': LatLng(geoPoint.latitude, geoPoint.longitude),
            };
          }).toList();
        });
  }

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
      });
    } catch (e) {
      print('Error saving camp data: $e');
      rethrow;
    }
  }

  Future<List<Camp>> getCampsOwnedOrBookmarked(String currentUserId) async {
    try {
      // Fetch camps owned by the user
      final ownerCampsQuery =
          await _firestore
              .collection('camps')
              .where('ownerId', isEqualTo: currentUserId)
              .get();

      // Fetch bookmarked camp IDs from bookmarks collection
      final bookmarkedDoc =
          await _firestore.collection('bookmarks').doc(currentUserId).get();

      final List<String> bookmarkedIds =
          bookmarkedDoc.exists
              ? List<String>.from(bookmarkedDoc.data()?['campIds'] ?? [])
              : [];

      final bookmarkedCamps = <DocumentSnapshot>[];

      if (bookmarkedIds.isNotEmpty) {
        final chunks = _chunkList(bookmarkedIds, 10);
        for (final chunk in chunks) {
          final snap =
              await _firestore
                  .collection('camps')
                  .where(FieldPath.documentId, whereIn: chunk)
                  .get();
          bookmarkedCamps.addAll(snap.docs);
        }
      }

      // Combine and deduplicate camps
      final Set<String> addedIds = {};
      final List<Camp> allCamps = [];

      for (final doc in [...ownerCampsQuery.docs, ...bookmarkedCamps]) {
        if (!addedIds.contains(doc.id)) {
          allCamps.add(Camp.fromDoc(doc));
          addedIds.add(doc.id);
        }
      }

      return allCamps;
    } catch (e) {
      print('Error fetching camps: $e');
      return [];
    }
  }

  List<List<String>> _chunkList(List<String> list, int chunkSize) {
    final chunks = <List<String>>[];
    for (var i = 0; i < list.length; i += chunkSize) {
      chunks.add(
        list.sublist(
          i,
          i + chunkSize > list.length ? list.length : i + chunkSize,
        ),
      );
    }
    return chunks;
  }
}

// Extension to convert Camp instance to Map<String, dynamic>
extension CampMapper on Camp {
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'CampName': name,
      'CampDescription': description,
      'CampType': campType,
      'CampFeatures': features,
      'location': LatLng(location.latitude, location.longitude),
      'ownerId': ownerId,
      'ownerUsername': ownerUsername,
    };
  }
}
