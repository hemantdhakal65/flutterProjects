import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/live_chat_provider.dart';
import '../services/chat_service.dart';
import 'dart:async';
import 'dart:math';

class EphemeralChatWindow extends StatefulWidget {
  final VoidCallback onClose;

  const EphemeralChatWindow({super.key, required this.onClose});

  @override
  State<EphemeralChatWindow> createState() => _EphemeralChatWindowState();
}

class _EphemeralChatWindowState extends State<EphemeralChatWindow> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late Timer _cleanupTimer;

  @override
  void initState() {
    super.initState();
    _cleanupTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      final provider = Provider.of<LiveChatProvider>(context, listen: false);
      final now = DateTime.now();
      provider.ephemeralMessages.removeWhere(
              (msg) => now.difference(msg['timestamp']).inSeconds > 10
      );
    });
  }

  @override
  void dispose() {
    _cleanupTimer.cancel();
    super.dispose();
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    final provider = Provider.of<LiveChatProvider>(context, listen: false);
    final formatted = ChatService.formatSnapchatMessage(_controller.text);

    provider.addEphemeralMessage({
      'text': _controller.text,
      'style': formatted['style'],
      'sender': 'me',
    });

    _controller.clear();

    Future.delayed(Duration(seconds: 1 + Random().nextInt(2)), () {
      provider.addEphemeralMessage({
        'text': 'Thanks for your message!',
        'style': {'color': Colors.white, 'fontSize': 16.0},
        'sender': 'them',
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LiveChatProvider>(context);

    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(0, 0, 0, 0.8), // Fixed deprecated withOpacity
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: widget.onClose,
                icon: const Icon(Icons.close, color: Colors.white),
              ),
              Text(
                provider.matchedUser?['name'] ?? 'Chat',
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              reverse: true,
              itemCount: provider.ephemeralMessages.length,
              itemBuilder: (context, index) {
                final msg = provider.ephemeralMessages.reversed.toList()[index];
                final isMe = msg['sender'] == 'me';

                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isMe ? const Color(0xFFFFFF00) : Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(15),
                        topRight: const Radius.circular(15),
                        bottomLeft: isMe ? const Radius.circular(15) : Radius.zero,
                        bottomRight: !isMe ? const Radius.circular(15) : Radius.zero,
                      ),
                    ),
                    child: Text(
                      msg['text'],
                      style: TextStyle(
                        fontSize: msg['style']?['fontSize'] ?? 16.0,
                        fontWeight: msg['style']?['fontWeight'],
                        fontStyle: msg['style']?['fontStyle'],
                        color: msg['style']?['color'] ?? Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: const Color.fromRGBO(255, 255, 255, 0.2), // Fixed deprecated withOpacity
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}