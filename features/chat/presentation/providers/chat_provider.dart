import 'package:flutter/material.dart';
import '../../data/models/conversation.dart';
import '../../data/models/message.dart';
import '../../services/firebase_service.dart';
import '../../data/repositories/chat_repository.dart';

class ChatProvider with ChangeNotifier {
  final ChatRepository _chatRepository;
  final FirebaseService _firebaseService;

  List<Conversation> _conversations = [];
  List<Message> _messages = [];
  bool _isLoading = false;
  String? _currentConversationId;

  ChatProvider(this._chatRepository, this._firebaseService);

  List<Conversation> get conversations => _conversations;
  List<Message> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get currentConversationId => _currentConversationId;

  Future<void> loadConversations() async {
    final userId = _firebaseService.currentUserId;
    if (userId.isEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      _chatRepository.getConversations(userId).listen((conversations) {
        _conversations = conversations;
        _isLoading = false;
        notifyListeners();
      });
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMessages(String conversationId) async {
    final userId = _firebaseService.currentUserId;
    if (userId.isEmpty) return;

    _currentConversationId = conversationId;
    _isLoading = true;
    notifyListeners();

    try {
      await _chatRepository.markMessagesAsSeen(conversationId, userId);

      _chatRepository.getMessages(conversationId).listen((messages) {
        _messages = messages;
        _isLoading = false;
        notifyListeners();
      });
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> sendTextMessage({
    required String conversationId,
    required String content,
  }) async {
    final userId = _firebaseService.currentUserId;
    if (userId.isEmpty) return;

    await _chatRepository.sendTextMessage(
      conversationId: conversationId,
      senderId: userId,
      content: content,
    );
  }

  Future<void> sendFileMessage({
    required String conversationId,
    required String filePath,
    required MessageType type,
  }) async {
    final userId = _firebaseService.currentUserId;
    if (userId.isEmpty) return;

    await _chatRepository.sendFileMessage(
      conversationId: conversationId,
      senderId: userId,
      filePath: filePath,
      type: type,
    );
  }

  Future<String> startNewConversation(String otherUserId) async {
    final userId = _firebaseService.currentUserId;
    if (userId.isEmpty) return '';

    return await _chatRepository.createConversation(
      userId,
      otherUserId,
    );
  }
}