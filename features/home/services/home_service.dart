import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../firebase/firestore_service.dart';
import '../models/post_model.dart';

class HomeService {
  final FirestoreService _firestore = FirestoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> createPost({
    required String title,
    required String description,
    required String category,
    required Map<String, dynamic> specifications,
    required double latitude,
    required double longitude,
  }) async {
    final user = _auth.currentUser!;
    final postData = {
      'userId': user.uid,
      'userName': user.displayName ?? 'Anonymous',
      'userImage': user.photoURL ?? '',
      'title': title,
      'description': description,
      'category': category,
      'timestamp': Timestamp.now(),
      'specifications': specifications,
      'reactions': {'likes': 0, 'loves': 0, 'wows': 0},
      'commentCount': 0,
      'latitude': latitude,
      'longitude': longitude,
    };
    await _firestore.addPost(postData);
  }

  Future<void> addComment(String postId, String content) async {
    final user = _auth.currentUser!;
    final commentData = {
      'postId': postId,
      'userId': user.uid,
      'userName': user.displayName ?? 'Anonymous',
      'userImage': user.photoURL ?? '',
      'content': content,
      'timestamp': Timestamp.now(),
    };
    await _firestore.addComment(postId, commentData);
  }

  Future<void> bookUser({
    required String postId,
    required String bookedUserId,
    required String category,
    required DateTime meetingTime,
  }) async {
    final bookerId = _auth.currentUser!.uid;
    final bookingData = {
      'postId': postId,
      'bookerId': bookerId,
      'bookedUserId': bookedUserId,
      'category': category,
      'bookingTime': Timestamp.now(),
      'meetingTime': meetingTime,
      'status': 'Requested',
    };
    await _firestore.createBooking(bookingData);
  }

  Future<void> updateReaction(String postId, String reactionType) async {
    await _firestore.posts.doc(postId).update({
      'reactions.$reactionType': FieldValue.increment(1),
    });
  }

  Stream<List<Post>> getNearbyPostsStream(
      double latitude, double longitude, double radius) {
    return _firestore
        .getNearbyPosts(latitude, longitude, radius)
        .map((snap) => snap.docs
        .map((doc) => Post.fromMap(doc.data(), doc.id))
        .toList());
  }
}
