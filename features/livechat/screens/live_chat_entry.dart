import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/live_chat_provider.dart';
import '../components/user_matching.dart';
import '../components/video_call_screen.dart';
import 'call_ended_screen.dart';

class LiveChatEntryScreen extends StatelessWidget {
  const LiveChatEntryScreen({super.key});

  Widget _buildFeature(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.green, size: 40),
          const SizedBox(width: 15),
          Text(text, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LiveChatProvider>(context);

    Widget buildStartScreen() {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Connect Nearby',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Video chat with people near you',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 30),
                const Icon(Icons.videocam, size: 150, color: Colors.green),
                const SizedBox(height: 30),
                _buildFeature(Icons.location_on, 'Location-based matching'),
                _buildFeature(Icons.chat, 'Ephemeral Snapchat-style chat'),
                _buildFeature(Icons.book, 'Book directly from chat'),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () => provider.callStatus = 'matching',
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Start Video Chat',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Connect with people nearby in real-time. '
                      'Chats disappear after the call unless saved.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return () {
      switch (provider.callStatus) {
        case 'idle':
          return buildStartScreen();
        case 'matching':
          return const UserMatching();
        case 'connecting':
        case 'connected':
          return const VideoCallScreen();
        case 'ended':
          return const CallEndedScreen();
        default:
          return buildStartScreen();
      }
    }();
  }
}