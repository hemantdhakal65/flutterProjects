import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';

class GenderSelection extends StatelessWidget {
  const GenderSelection({super.key});

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);

    return AlertDialog(
      title: const Text('Select Gender'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RadioListTile<String>(
            title: const Text('Male'),
            value: 'Male',
            groupValue: profileProvider.gender,
            onChanged: (value) {
              profileProvider.setGender(value!);
              Navigator.pop(context);
            },
          ),
          RadioListTile<String>(
            title: const Text('Female'),
            value: 'Female',
            groupValue: profileProvider.gender,
            onChanged: (value) {
              profileProvider.setGender(value!);
              Navigator.pop(context);
            },
          ),
          RadioListTile<String>(
            title: const Text('Non-binary'),
            value: 'Non-binary',
            groupValue: profileProvider.gender,
            onChanged: (value) {
              profileProvider.setGender(value!);
              Navigator.pop(context);
            },
          ),
          RadioListTile<String>(
            title: const Text('Prefer not to say'),
            value: 'Prefer not to say',
            groupValue: profileProvider.gender,
            onChanged: (value) {
              profileProvider.setGender(value!);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}