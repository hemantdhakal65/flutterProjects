import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math' as math;
import '../auth/models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// ─── USERS ────────────────────────────────────────────────────────────────

  CollectionReference<Map<String, dynamic>> get users =>
      _db.collection('users');

  Future<void> createUser(UserModel user) async {
    try {
      await users.doc(user.uid).set({
        'uid': user.uid,
        'isAnonymous': user.isAnonymous,
        'email': user.email,
        'phone': user.phone,
        'username': user.username,
        'dob': user.dob?.millisecondsSinceEpoch,
        'reason': user.reason,
        'customReason': user.customReason,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  Future<UserModel?> getUser(String uid) async {
    final doc = await users.doc(uid).get();
    return doc.exists
        ? UserModel.fromMap(doc.data()!)
        : null;
  }

  /// ─── POSTS & COMMENTS ──────────────────────────────────────────────────────

  CollectionReference<Map<String, dynamic>> get posts =>
      _db.collection('posts');

  Future<DocumentReference<Map<String, dynamic>>> addPost(
      Map<String, dynamic> postData) {
    return posts.add(postData);
  }

  Future<DocumentReference<Map<String, dynamic>>> addComment(
      String postId,
      Map<String, dynamic> commentData,
      ) {
    return posts
        .doc(postId)
        .collection('comments')
        .add(commentData);
  }

  /// ─── BOOKINGS ──────────────────────────────────────────────────────────────

  CollectionReference<Map<String, dynamic>> get bookings =>
      _db.collection('bookings');

  Future<DocumentReference<Map<String, dynamic>>> createBooking(
      Map<String, dynamic> bookingData,
      ) {
    return bookings.add(bookingData);
  }

  /// ─── NEARBY POSTS STREAM ────────────────────────────────────────────────────

  /// Performs a lat/lon "box" query to approximate a circular radius.
  Stream<QuerySnapshot<Map<String, dynamic>>> getNearbyPosts(
      double latitude,
      double longitude,
      double radiusKm,
      ) {
    // 1° of latitude ≈ 111 km
    final deltaLat = radiusKm / 111.0;

    // 1° of longitude ≈ 111 km × cos(latitude in radians)
    final latRad = latitude * (math.pi / 180.0);
    final deltaLon = radiusKm / (111.0 * math.cos(latRad));

    final minLat = latitude - deltaLat;
    final maxLat = latitude + deltaLat;
    final minLon = longitude - deltaLon;
    final maxLon = longitude + deltaLon;

    return posts
        .where('latitude', isGreaterThan: minLat)
        .where('latitude', isLessThan: maxLat)
        .where('longitude', isGreaterThan: minLon)
        .where('longitude', isLessThan: maxLon)
        .snapshots();
  }
}