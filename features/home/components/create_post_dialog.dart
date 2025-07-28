// lib/features/home/components/create_post_dialog.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/home_provider.dart';

class CreatePostDialog extends StatefulWidget {
  const CreatePostDialog({super.key});

  @override
  State<CreatePostDialog> createState() => _CreatePostDialogState();
}

class _CreatePostDialogState extends State<CreatePostDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedCategory = 'Girlfriend';
  double _height = 170;
  double _weight = 65;
  String _bodyType = 'Average';
  String _skills = '';

  final List<String> _categories = [
    'Girlfriend', 'Boyfriend', 'Best Friend', 'Mother',
    'Father', 'Sister', 'Brother', 'Gym Partner',
    'Travel Buddy', 'Study Partner', 'Drink Partner',
    'Talk Partner', 'Plumber', 'Electrician', 'Chef'
  ];
  final List<String> _bodyTypes = [
    'Slim', 'Average', 'Athletic', 'Muscular', 'Curvy'
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Grab provider and navigator *before* any async gaps:
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    final navigator = Navigator.of(context);

    return AlertDialog(
      title: const Text('Create New Post'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title*',
                hintText: 'What are you looking for?',
              ),
              validator: (v) =>
              v == null || v.isEmpty ? 'Please enter a title' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description*',
                hintText: 'Describe what you need...',
              ),
              maxLines: 3,
              validator: (v) =>
              v == null || v.isEmpty ? 'Please enter a description' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              items: _categories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedCategory = v!),
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            const SizedBox(height: 16),
            const Text('Physical Specifications',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Height: ${_height.toStringAsFixed(0)} cm'),
                    Slider(
                      value: _height,
                      min: 100,
                      max: 220,
                      divisions: 120,
                      onChanged: (v) => setState(() => _height = v),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Weight: ${_weight.toStringAsFixed(0)} kg'),
                    Slider(
                      value: _weight,
                      min: 40,
                      max: 150,
                      divisions: 110,
                      onChanged: (v) => setState(() => _weight = v),
                    ),
                  ],
                ),
              ),
            ]),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _bodyType,
              items: _bodyTypes
                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
              onChanged: (v) => setState(() => _bodyType = v!),
              decoration: const InputDecoration(labelText: 'Body Type'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              onChanged: (v) => _skills = v,
              decoration: const InputDecoration(
                labelText: 'Skills/Abilities',
                hintText: 'What can you offer?',
              ),
              maxLines: 2,
            ),
          ]),
        ),
      ),
      actions: [
        TextButton(onPressed: () => navigator.pop(), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              await homeProvider.createPost(
                title: _titleController.text,
                description: _descriptionController.text,
                category: _selectedCategory,
                specifications: {
                  'height': _height,
                  'weight': _weight,
                  'bodyType': _bodyType,
                  'skills': _skills,
                },
              );
              navigator.pop();
            }
          },
          child: const Text('Post'),
        ),
      ],
    );
  }
}
