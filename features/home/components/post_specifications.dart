import 'package:flutter/material.dart';

class PostSpecifications extends StatelessWidget {
  final Map<String, dynamic> specifications;

  const PostSpecifications({super.key, required this.specifications});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Specifications',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                _buildSpecItem('Height', '${specifications['height']?.toStringAsFixed(0) ?? 'N/A'} cm'),
                _buildSpecItem('Weight', '${specifications['weight']?.toStringAsFixed(0) ?? 'N/A'} kg'),
                _buildSpecItem('Body Type', specifications['bodyType'] ?? 'N/A'),
                if (specifications['skills']?.isNotEmpty == true)
                  _buildSpecItem('Skills', specifications['skills']),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}