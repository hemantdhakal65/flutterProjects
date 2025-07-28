import 'package:cloud_firestore/cloud_firestore.dart';

class ChatUser {
  final String id;
  final String name;
  final String? avatarUrl;
  final String email;
  final DateTime createdAt;
  final DateTime lastSeen;

  ChatUser({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.email,
    required this.createdAt,
    required this.lastSeen,
  });

  factory ChatUser.fromMap(Map<String, dynamic> map) {
    return ChatUser(
      id: map['uid'] ?? map['id'],
      name: map['name'],
      avatarUrl: map['avatarUrl'],
      email: map['email'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      lastSeen: (map['lastSeen'] as Timestamp).toDate(),
    );
  }
}