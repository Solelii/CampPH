import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';

class CampFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveCampData({
    required LatLng location,
    required String name,
    required String description,
    required Set<String> tags,
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
      });
    } catch (e) {
      print('Error saving camp data: $e');
      rethrow; // or handle as needed
    }
  }
}
