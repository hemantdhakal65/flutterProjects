import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';

class ThemeSwitchCard extends StatelessWidget {
  const ThemeSwitchCard({super.key});

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Appearance',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.dark_mode),
                const SizedBox(width: 16),
                const Text('Dark Mode'),
                const Spacer(),
                Switch(
                  value: profileProvider.isDarkMode,
                  onChanged: profileProvider.toggleTheme,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.volume_up),
                const SizedBox(width: 16),
                const Text('App Sounds'),
                const Spacer(),
                Switch(
                  value: profileProvider.isVolumeOn,
                  onChanged: (_) => profileProvider.toggleVolume(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}