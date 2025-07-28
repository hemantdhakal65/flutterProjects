import 'package:flutter/material.dart';

class DeleteAccountDialog extends StatelessWidget {
  const DeleteAccountDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Account'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('This will permanently delete your account and all associated data.'),
          const SizedBox(height: 20),
          const Text('Before deleting, please note:'),
          const SizedBox(height: 10),
          _buildBulletPoint('All your bookings will be canceled'),
          _buildBulletPoint('Your profile information will be deleted'),
          _buildBulletPoint('This action cannot be undone'),
          const SizedBox(height: 20),
          const Text('Enter your password to confirm:'),
          const SizedBox(height: 10),
          TextField(
            obscureText: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            // Delete account logic
            Navigator.pop(context);
            Navigator.pop(context); // Close confirmation dialog
          },
          child: const Text('Delete Account', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• '),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}