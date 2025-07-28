import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/category_provider.dart';
import '../components/category_search_bar.dart';
import '../components/category_grid.dart';
import 'category_results_screen.dart'; // Added import

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CategoryProvider>(context);
    final searchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Your Match'),
      ),
      body: Column(
        children: [
          CategorySearchBar(
            controller: searchController,
            onSearchChanged: provider.setSearchQuery,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Popular Categories',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: CategoryGrid(
              categories: provider.filteredCategories,
              onCategorySelected: (category) {
                provider.setSelectedCategory(category);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CategoryResultsScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}