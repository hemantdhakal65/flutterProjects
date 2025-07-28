import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import 'chat_screen.dart';
import '../../utils/time_utils.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);

    if (chatProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (chatProvider.conversations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No conversations yet'),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/new-chat'),
              child: const Text('Start a new chat'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: chatProvider.conversations.length,
      itemBuilder: (context, index) {
        final convo = chatProvider.conversations[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: convo.userAvatar.isNotEmpty
                ? NetworkImage(convo.userAvatar)
                : null,
            child: convo.userAvatar.isEmpty ? const Icon(Icons.person) : null,
          ),
          title: Text(convo.userName),
          subtitle: Text(
            convo.lastMessage,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                TimeUtils.formatTime(convo.lastMessageTime),
                style: const TextStyle(fontSize: 12),
              ),
              if (convo.unreadCount > 0)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    convo.unreadCount.toString(),
                    style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white
                    ),
                  ),
                ),
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(
                  conversationId: convo.id,
                  receiverId: convo.userId,
                  receiverName: convo.userName,
                ),
              ),
            );
          },
        );
      },
    );
  }
}