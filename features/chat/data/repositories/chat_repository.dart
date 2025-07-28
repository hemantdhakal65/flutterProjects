import '../models/message.dart';
import '../models/conversation.dart';
import '../../services/firebase_service.dart';

class ChatRepository {
  final FirebaseService _firebaseService;

  ChatRepository(this._firebaseService);

  Stream<List<Conversation>> getConversations(String userId) {
    return _firebaseService.getConversations(userId);
  }

  Stream<List<Message>> getMessages(String conversationId) {
    return _firebaseService.getMessages(conversationId);
  }

  Future<void> sendTextMessage({
    required String conversationId,
    required String senderId,
    required String content,
  }) async {
    await _firebaseService.sendMessage(
      conversationId: conversationId,
      senderId: senderId,
      content: content,
      type: MessageType.text,
    );
  }

  Future<void> sendFileMessage({
    required String conversationId,
    required String senderId,
    required String filePath,
    required MessageType type,
  }) async {
    final downloadUrl = await _firebaseService.uploadFile(filePath, conversationId);
    await _firebaseService.sendMessage(
      conversationId: conversationId,
      senderId: senderId,
      content: downloadUrl,
      type: type,
    );
  }

  Future<String> createConversation(String currentUserId, String otherUserId) {
    return _firebaseService.createConversation(currentUserId, otherUserId);
  }

  Future<void> markMessagesAsSeen(String conversationId, String userId) async {
    await _firebaseService.markMessagesAsSeen(conversationId, userId);
  }
}