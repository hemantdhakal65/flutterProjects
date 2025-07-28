import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/live_chat_provider.dart';
import '../services/chat_service.dart';

class SwitchToMessageButton extends StatefulWidget {
  const SwitchToMessageButton({super.key});

  @override
  State<SwitchToMessageButton> createState() => _SwitchToMessageButtonState();
}

class _SwitchToMessageButtonState extends State<SwitchToMessageButton> {
  Future<void> _saveChat() async {
    if (!mounted) return;

    final provider = Provider.of<LiveChatProvider>(context, listen: false);
    final success = await ChatService.saveChatToMessages(
      'current-user-id',
      provider.matchedUser?['id'] ?? 'unknown',
      provider.ephemeralMessages,
    );

    if (!mounted) return;

    if (success) {
      provider.setShouldSaveChat(true);
      provider.clearEphemeralMessages();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Chat saved to messages')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save chat')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: _saveChat,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: const BorderSide(color: Colors.white),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      icon: const Icon(Icons.message, size: 20),
      label: const Text('Save to Messages'),
    );
  }
}