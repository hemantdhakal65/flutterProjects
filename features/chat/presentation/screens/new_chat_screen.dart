import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/chat_user.dart';
import '../../services/firebase_service.dart';
import '../providers/chat_provider.dart';
import 'chat_screen.dart';

class NewChatScreen extends StatefulWidget {
  const NewChatScreen({super.key});

  @override
  State<NewChatScreen> createState() => _NewChatScreenState();
}

class _NewChatScreenState extends State<NewChatScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<ChatUser> _searchResults = [];

  @override
  Widget build(BuildContext context) {
    final firebaseService = Provider.of<FirebaseService>(context);
    final chatProvider = Provider.of<ChatProvider>(context);
    final currentUserId = firebaseService.currentUserId;

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search users...',
            border: InputBorder.none,
          ),
          onChanged: (value) {
            if (value.isNotEmpty) {
              firebaseService.searchUsers(value).listen((users) {
                if (mounted) {
                  setState(() {
                    _searchResults = users
                        .where((user) => user.id != currentUserId)
                        .toList();
                  });
                }
              });
            } else {
              if (mounted) setState(() => _searchResults = []);
            }
          },
        ),
      ),
      body: ListView.builder(
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          final user = _searchResults[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: user.avatarUrl != null
                  ? NetworkImage(user.avatarUrl!)
                  : null,
              child: user.avatarUrl == null
                  ? const Icon(Icons.person)
                  : null,
            ),
            title: Text(user.name),
            subtitle: Text(user.email),
            onTap: () => _startConversation(user, chatProvider),
          );
        },
      ),
    );
  }

  Future<void> _startConversation(ChatUser user, ChatProvider chatProvider) async {
    final conversationId = await chatProvider.startNewConversation(user.id);

    // FIXED: Check mounted immediately before using context
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ChatScreen(
          conversationId: conversationId,
          receiverId: user.id,
          receiverName: user.name,
        ),
      ),
    );
  }
}