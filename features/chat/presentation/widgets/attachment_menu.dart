import 'package:flutter/material.dart';

class AttachmentMenu extends StatelessWidget {
  final VoidCallback onImagePressed;
  final VoidCallback onVideoPressed;
  final VoidCallback onAudioPressed;
  final VoidCallback onDocumentPressed;

  const AttachmentMenu({
    super.key,
    required this.onImagePressed,
    required this.onVideoPressed,
    required this.onAudioPressed,
    required this.onDocumentPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.grey[100],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildAttachmentOption(Icons.image, 'Photo', onImagePressed),
          _buildAttachmentOption(Icons.videocam, 'Video', onVideoPressed),
          _buildAttachmentOption(Icons.headset, 'Audio', onAudioPressed),
          _buildAttachmentOption(Icons.insert_drive_file, 'Document', onDocumentPressed),
        ],
      ),
    );
  }

  Widget _buildAttachmentOption(IconData icon, String label, VoidCallback onPressed) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon),
          onPressed: onPressed,
        ),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}