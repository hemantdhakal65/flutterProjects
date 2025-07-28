import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../data/models/message.dart';
import '../data/models/conversation.dart';
import '../data/models/chat_user.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  User? get currentUser => _auth.currentUser;
  String get currentUserId => _auth.currentUser?.uid ?? '';

  Stream<User?> get userStream => _auth.authStateChanges();

  Future<void> createUserDocument(User user, String name) async {
    await _firestore.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'email': user.email,
      'name': name,
      'createdAt': FieldValue.serverTimestamp(),
      'lastSeen': FieldValue.serverTimestamp(),
      'avatarUrl': '',
    });
  }

  Future<ChatUser> getUser(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    return ChatUser.fromMap(doc.data()!);
  }

  Stream<List<ChatUser>> searchUsers(String query) {
    return _firestore.collection('users')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThan: '${query}z')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => ChatUser.fromMap(doc.data()))
        .toList());
  }

  Future<String> createConversation(String currentUserId, String otherUserId) async {
    final participants = [currentUserId, otherUserId]..sort();
    final conversationId = participants.join('_');

    await _firestore.collection('conversations').doc(conversationId).set({
      'id': conversationId,
      'participants': participants,
      'createdAt': FieldValue.serverTimestamp(),
      'lastMessage': '',
      'lastMessageTime': FieldValue.serverTimestamp(),
      'unreadCount': {currentUserId: 0, otherUserId: 0},
    });

    return conversationId;
  }

  Stream<List<Conversation>> getConversations(String userId) {
    return _firestore.collection('conversations')
        .where('participants', arrayContains: userId)
        .snapshots()
        .asyncMap((snapshot) async {
      final conversations = <Conversation>[];

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final participants = List<String>.from(data['participants']);
        final otherUserId = participants.firstWhere((id) => id != userId);

        final userDoc = await _firestore.collection('users').doc(otherUserId).get();
        final userData = userDoc.data()!;

        conversations.add(Conversation(
          id: doc.id,
          userId: otherUserId,
          userName: userData['name'],
          userAvatar: userData['avatarUrl'] ?? '',
          lastMessage: data['lastMessage'] ?? '',
          lastMessageTime: (data['lastMessageTime'] as Timestamp).toDate(),
          unreadCount: data['unreadCount']?[userId] ?? 0,
        ));
      }

      return conversations;
    });
  }

  Stream<List<Message>> getMessages(String conversationId) {
    return _firestore.collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Message.fromMap(doc.data()))
        .toList());
  }

  Future<void> sendMessage({
    required String conversationId,
    required String senderId,
    required String content,
    required MessageType type,
  }) async {
    final message = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: senderId,
      content: content,
      timestamp: DateTime.now(),
      type: type,
    );

    await _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .doc(message.id)
        .set(message.toMap());

    final participants = await _getParticipants(conversationId);
    final Map<String, dynamic> unreadCountUpdate = {};
    for (final participant in participants) {
      if (participant != senderId) {
        unreadCountUpdate['unreadCount.$participant'] = FieldValue.increment(1);
      }
    }

    await _firestore.collection('conversations').doc(conversationId).update({
      'lastMessage': content,
      'lastMessageTime': FieldValue.serverTimestamp(),
      ...unreadCountUpdate,
    });
  }

  Future<String> uploadFile(String path, String conversationId) async {
    final fileName = path.split('/').last;
    final ref = _storage.ref().child('chats/$conversationId/$fileName');
    await ref.putFile(File(path));
    return await ref.getDownloadURL();
  }

  Future<void> markMessagesAsSeen(String conversationId, String userId) async {
    await _firestore.collection('conversations').doc(conversationId).update({
      'unreadCount.$userId': 0,
    });
  }

  Future<List<String>> _getParticipants(String conversationId) async {
    final doc = await _firestore.collection('conversations').doc(conversationId).get();
    return List<String>.from(doc['participants']);
  }
}
