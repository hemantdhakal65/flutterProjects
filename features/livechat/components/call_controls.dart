import 'package:flutter/material.dart';
import 'booking_form.dart';
import 'switch_to_message_button.dart';

class CallControls extends StatelessWidget {
  final VoidCallback onDecline;
  final VoidCallback onToggleMute;
  final VoidCallback onToggleCamera;
  final bool isMuted;
  final bool isCameraOff;

  const CallControls({
    super.key,
    required this.onDecline,
    required this.onToggleMute,
    required this.onToggleCamera,
    required this.isMuted,
    required this.isCameraOff,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      color: Colors.black54,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: onToggleMute,
                icon: Icon(
                  isMuted ? Icons.mic_off : Icons.mic,
                  color: Colors.white,
                  size: 30,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black54,
                  padding: const EdgeInsets.all(15),
                ),
              ),
              IconButton(
                onPressed: onToggleCamera,
                icon: Icon(
                  isCameraOff ? Icons.videocam_off : Icons.videocam,
                  color: Colors.white,
                  size: 30,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black54,
                  padding: const EdgeInsets.all(15),
                ),
              ),
              IconButton(
                onPressed: () => showModalBottomSheet(
                  context: context,
                  builder: (context) => const BookingForm(),
                ),
                icon: const Icon(Icons.book, color: Colors.white, size: 30),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.all(15),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: onDecline,
            child: Container(
              width: 70,
              height: 70,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.call_end,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const SwitchToMessageButton(),
        ],
      ),
    );
  }
}