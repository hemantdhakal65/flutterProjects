import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';
import 'dart:io';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);

    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: profileProvider.profileImageUrl != null
                  ? FileImage(File(profileProvider.profileImageUrl!))
                  : const AssetImage('assets/default_avatar.png'),
              child: profileProvider.profileImageUrl == null
                  ? const Icon(Icons.person, size: 60)
                  : null,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: IconButton(
                icon: const Icon(Icons.camera_alt, color: Colors.white),
                onPressed: () => _changeProfilePicture(context),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          profileProvider.name ?? 'User',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 4),
        Text(
          profileProvider.email,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  void _changeProfilePicture(BuildContext context) async {
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);

    // Simulate image selection
    await profileProvider.setProfileImage('path/to/image.jpg');
  }
}
