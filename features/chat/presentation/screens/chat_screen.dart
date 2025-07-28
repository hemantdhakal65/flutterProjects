import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../widgets/message_bubble.dart';
import '../widgets/chat_input.dart';
import '../widgets/attachment_menu.dart';
import '../providers/chat_provider.dart';
import '../../data/models/message.dart';
import '../../services/firebase_service.dart';

class ChatScreen extends StatefulWidget {
  final String conversationId;
  final String receiverId;
  final String receiverName;

  const ChatScreen({
    super.key,
    required this.conversationId,
    required this.receiverId,
    required this.receiverName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late String _currentUserId;

  @override
  void initState() {
    super.initState();
    final firebaseService = Provider.of<FirebaseService>(context, listen: false);
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    _currentUserId = firebaseService.currentUserId;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // FIXED: Removed the second parameter
      chatProvider.loadMessages(widget.conversationId);
    });
  }

  Future<void> _pickAndSendFile(MessageType type) async {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);

    try {
      String? filePath;
      final ImagePicker picker = ImagePicker();

      if (type == MessageType.image) {
        final image = await picker.pickImage(source: ImageSource.gallery);
        if (image == null) return;
        filePath = image.path;
      } else if (type == MessageType.video) {
        final video = await picker.pickVideo(source: ImageSource.gallery);
        if (video == null) return;
        filePath = video.path;
      } else {
        final result = await FilePicker.platform.pickFiles(
          type: type == MessageType.audio
              ? FileType.audio
              : FileType.any,
        );
        if (result == null || result.files.isEmpty) return;
        filePath = result.files.first.path;
      }

      if (filePath != null && mounted) {
        await chatProvider.sendFileMessage(
          conversationId: widget.conversationId,
          filePath: filePath,
          type: type,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send file: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverName),
        actions: [
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: chatProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
              controller: _scrollController,
              reverse: true,
              itemCount: chatProvider.messages.length,
              itemBuilder: (context, index) {
                final message = chatProvider.messages[index];
                return MessageBubble(
                  message: message,
                  isMe: message.senderId == _currentUserId,
                );
              },
            ),
          ),
          AttachmentMenu(
            onImagePressed: () => _pickAndSendFile(MessageType.image),
            onVideoPressed: () => _pickAndSendFile(MessageType.video),
            onAudioPressed: () => _pickAndSendFile(MessageType.audio),
            onDocumentPressed: () => _pickAndSendFile(MessageType.document),
          ),
          ChatInput(
            controller: _messageController,
            onSend: (text) => _sendMessage(text),
          ),
        ],
      ),
    );
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.sendTextMessage(
      conversationId: widget.conversationId,
      content: text,
    );

    _messageController.clear();
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
}