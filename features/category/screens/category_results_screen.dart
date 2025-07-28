import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/category_provider.dart';
import '../components/category_filter_chip.dart';
import '../components/distance_slider.dart';
import '../components/category_user_card.dart';
import '../models/category_model.dart'; // Added import
import '../models/user_model.dart'; // Added import

class CategoryResultsScreen extends StatelessWidget {
  const CategoryResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CategoryProvider>(context);
    final category = provider.selectedCategory;

    if (category == null) {
      return const Scaffold(
        body: Center(child: Text('No category selected')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${category.icon} ${category.name}'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.name,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(category.description),
                const SizedBox(height: 16),
                const Text('Filters', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    CategoryFilterChip(
                      label: 'Male',
                      selected: provider.genderFilters.contains('Male'),
                      onSelected: () => provider.toggleGenderFilter('Male'),
                    ),
                    CategoryFilterChip(
                      label: 'Female',
                      selected: provider.genderFilters.contains('Female'),
                      onSelected: () => provider.toggleGenderFilter('Female'),
                    ),
                    CategoryFilterChip(
                      label: 'Online Only',
                      selected: provider.onlineOnly,
                      onSelected: () => provider.setOnlineOnly(!provider.onlineOnly),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                DistanceSlider(
                  maxDistance: provider.maxDistance,
                  onChanged: provider.setMaxDistance,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text(
                      'Available Matches',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Text('${provider.filteredUsers.length} found'),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: provider.filteredUsers.length,
              itemBuilder: (context, index) {
                final user = provider.filteredUsers[index];
                return CategoryUserCard(
                  user: user,
                  onBook: () => _bookUser(context, user, category),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _bookUser(BuildContext context, User user, Category category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Book ${user.name}?'),
        content: Text('Confirm booking for ${category.name.toLowerCase()} services'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${user.name} booked as ${category.name}!'),
                ),
              );
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}