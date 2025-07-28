import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/post_model.dart';
import '../providers/home_provider.dart';
import 'post_specifications.dart';
import 'reaction_button.dart';
import 'comment_section.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: post.userImage.isNotEmpty
                  ? NetworkImage(post.userImage)
                  : null,
              child: post.userImage.isEmpty ? const Icon(Icons.person) : null,
            ),
            title: Text(post.userName),
            subtitle: Text(DateFormat.yMMMd().add_jm().format(post.timestamp)),
            trailing: ElevatedButton(
              onPressed: () => _bookUser(context),
              child: const Text('Book'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Chip(
                  label: Text(post.category),
                  backgroundColor: Theme.of(context).primaryColor.withAlpha(51),
                ),
                const SizedBox(height: 8),
                Text(
                  post.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(post.description),
                const SizedBox(height: 16),
              ],
            ),
          ),
          PostSpecifications(specifications: post.specifications),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ReactionButton(
                  icon: Icons.favorite,
                  label: 'Love (${post.reactions['loves']})',
                  color: Colors.red,
                  onPressed: () => _reactToPost(context, 'loves'),
                ),
                ReactionButton(
                  icon: Icons.thumb_up,
                  label: 'Like (${post.reactions['likes']})',
                  color: Colors.blue,
                  onPressed: () => _reactToPost(context, 'likes'),
                ),
                ReactionButton(
                  icon: Icons.share,
                  label: 'Share',
                  color: Colors.green,
                  onPressed: () => _sharePost(context),
                ),
              ],
            ),
          ),
          CommentSection(
            postId: post.id,
            commentCount: post.commentCount,
          ),
        ],
      ),
    );
  }

  void _reactToPost(BuildContext context, String reactionType) {
    Provider.of<HomeProvider>(context, listen: false)
        .reactToPost(post.id, reactionType);
  }

  void _bookUser(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Booking'),
        content: const Text('Are you sure you want to book this user?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<HomeProvider>(context, listen: false).bookUser(
                postId: post.id,
                bookedUserId: post.userId,
                category: post.category,
                meetingTime: DateTime.now().add(const Duration(days: 1)),
              );
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Booking request sent to ${post.userName}'),
                ),
              );
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _sharePost(BuildContext context) {
    // Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Post shared!')),
    );
  }
}