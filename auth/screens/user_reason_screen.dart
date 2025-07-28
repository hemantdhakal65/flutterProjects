import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/user_repository.dart';
import '../utils/auth_constants.dart';
import '../widgets/reason_selection_card.dart';
import '../../features/home/screens/home_screen.dart';

class UserReasonScreen extends StatefulWidget {
  final UserModel user;

  const UserReasonScreen({super.key, required this.user});

  @override
  State<UserReasonScreen> createState() => _UserReasonScreenState();
}

class _UserReasonScreenState extends State<UserReasonScreen> {
  String? _selectedReason;
  final _customController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Why are you here?')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select a reason:', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            ...AuthConstants.reasons.map((reason) => ReasonSelectionCard(
              reason: reason,
              isSelected: _selectedReason == reason,
              onSelect: () => setState(() => _selectedReason = reason),
            )),
            const SizedBox(height: 20),
            TextField(
              controller: _customController,
              decoration: const InputDecoration(
                labelText: 'Custom Reason (Optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: _completeRegistration,
                child: const Text('Finish Registration'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _completeRegistration() async {
    // Capture navigator before the async call
    final navigator = Navigator.of(context);

    final updated = widget.user.copyWith(
      reason: _selectedReason,
      customReason:
      _customController.text.isNotEmpty ? _customController.text : null,
    );

    await UserRepository().createUser(updated);

    // Safe to navigate after await
    navigator.pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }
}
