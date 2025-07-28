import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/home_provider.dart';
import '../components/user_search_bar.dart';
import '../components/create_post_dialog.dart';
import '../components/post_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeProvider>(context, listen: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('BookMe Feed'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => const CreatePostDialog(),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          UserSearchBar(
            controller: _searchController,
            onSearchChanged: provider.setSearchQuery,
          ),
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : provider.filteredPosts.isEmpty
                ? const Center(child: Text('No posts found nearby'))
                : ListView.builder(
              itemCount: provider.filteredPosts.length,
              itemBuilder: (context, index) {
                return PostCard(post: provider.filteredPosts[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => const CreatePostDialog(),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}