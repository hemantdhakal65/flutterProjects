import 'package:flutter/material.dart';
import '../models/user_model.dart'; // Fixed import path

class CategoryUserCard extends StatelessWidget {
  final User user;
  final VoidCallback onBook;

  const CategoryUserCard({
    super.key,
    required this.user,
    required this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[200],
                  child: user.imageUrl.isEmpty
                      ? const Icon(Icons.person, size: 30)
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            user.name,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          if (user.isOnline)
                            Container(
                              margin: const EdgeInsets.only(left: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                'Online',
                                style: TextStyle(color: Colors.white, fontSize: 12),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          Text('${user.rating}'),
                          const SizedBox(width: 16),
                          const Icon(Icons.location_on, size: 16),
                          Text('${user.distance.toStringAsFixed(1)} km'),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text('${user.age} years, ${user.gender}'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              user.bio,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Wrap(
                  spacing: 8,
                  children: user.categories
                      .take(3)
                      .map((cat) => Chip(
                    label: Text(cat),
                    backgroundColor: Colors.blue[50],
                  ))
                      .toList(),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: onBook,
                  child: const Text('Book Now'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}