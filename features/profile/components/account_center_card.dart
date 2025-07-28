import 'package:flutter/material.dart';

class AccountCenterCard extends StatelessWidget {
  const AccountCenterCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Account Center',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            _buildInfoRow(Icons.person, 'Personal Information'),
            _buildInfoRow(Icons.security, 'Security'),
            _buildInfoRow(Icons.privacy_tip, 'Privacy Settings'),
            _buildInfoRow(Icons.language, 'Language & Region'),
            _buildInfoRow(Icons.payment, 'Payment Methods'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 28),
          const SizedBox(width: 16),
          Text(text, style: const TextStyle(fontSize: 16)),
          const Spacer(),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}