import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';
import '../components/profile_header.dart';
import '../components/setting_tile.dart';
import '../components/theme_switch_card.dart';
import '../components/account_center_card.dart';
import '../components/gender_selection.dart';
import '../components/delete_account_dialog.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _editProfile(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const ProfileHeader(),
            const ThemeSwitchCard(),
            const AccountCenterCard(),
            _buildSectionTitle('Preferences'),
            SettingTile(
              icon: Icons.transgender,
              title: 'Gender',
              trailing: Text(profileProvider.gender ?? 'Not set'),
              onTap: () => showDialog(
                context: context,
                builder: (context) => const GenderSelection(),
              ),
            ),
            SettingTile(
              icon: Icons.notifications,
              title: 'Notification Settings',
              onTap: () => _showNotificationSettings(context),
            ),
            SettingTile(
              icon: Icons.language,
              title: 'Language',
              trailing: const Text('English'),
              onTap: () => _showLanguageSelection(context),
            ),
            _buildSectionTitle('Account'),
            SettingTile(
              icon: Icons.delete,
              title: 'Delete Account',
              onTap: () => _deleteAccount(context),
              showDivider: false,
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  void _editProfile(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final nameController = TextEditingController(text: profileProvider.name);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                profileProvider.updateName(nameController.text);
                Navigator.pop(context);
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  void _showNotificationSettings(BuildContext context) {
    // Implementation would go here
  }

  void _showLanguageSelection(BuildContext context) {
    // Implementation would go here
  }

  Future<void> _deleteAccount(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => const DeleteAccountDialog(),
    );
  }
}