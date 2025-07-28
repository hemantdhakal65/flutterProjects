import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String userId;
  final String userName;
  final String userImage;
  final String title;
  final String description;
  final String category;
  final DateTime timestamp;
  final Map<String, dynamic> specifications;
  final Map<String, dynamic> reactions;
  final int commentCount;
  final double latitude;
  final double longitude;

  Post({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.title,
    required this.description,
    required this.category,
    required this.timestamp,
    required this.specifications,
    required this.reactions,
    required this.commentCount,
    required this.latitude,
    required this.longitude,
  });

  factory Post.fromMap(Map<String, dynamic> data, String id) {
    return Post(
      id: id,
      userId: data['userId'],
      userName: data['userName'],
      userImage: data['userImage'],
      title: data['title'],
      description: data['description'],
      category: data['category'],
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      specifications: Map<String, dynamic>.from(data['specifications']),
      reactions: Map<String, dynamic>.from(data['reactions']),
      commentCount: data['commentCount'],
      latitude: data['latitude'],
      longitude: data['longitude'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'userImage': userImage,
      'title': title,
      'description': description,
      'category': category,
      'timestamp': Timestamp.fromDate(timestamp),
      'specifications': specifications,
      'reactions': reactions,
      'commentCount': commentCount,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}