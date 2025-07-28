import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/home_provider.dart';

class CommentSection extends StatefulWidget {
  final String postId;
  final int commentCount;

  const CommentSection({
    super.key,
    required this.postId,
    required this.commentCount,
  });

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final _commentController = TextEditingController();
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text('${widget.commentCount} comments'),
          trailing: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
          onTap: () => setState(() => _isExpanded = !_isExpanded),
        ),
        if (_isExpanded) ...[
          // In real app, fetch comments from Firestore
          const ListTile(
            leading: CircleAvatar(child: Icon(Icons.person)),
            title: Text('John Doe'),
            subtitle: Text('This looks interesting!'),
          ),
          const ListTile(
            leading: CircleAvatar(child: Icon(Icons.person)),
            title: Text('Jane Smith'),
            subtitle: Text('I can help with that!'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: 'Add a comment...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (_commentController.text.isNotEmpty) {
                      Provider.of<HomeProvider>(context, listen: false)
                          .addComment(widget.postId, _commentController.text);
                      _commentController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}