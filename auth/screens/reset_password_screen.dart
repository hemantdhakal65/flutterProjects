import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/password_input_field.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String oobCode;

  const ResetPasswordScreen({super.key, required this.oobCode});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Set your new password',
                  style: TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
              PasswordInputField(
                controller: _passwordController,
                label: 'New Password',
              ),
              const SizedBox(height: 20),
              PasswordInputField(
                controller: _confirmController,
                label: 'Confirm Password',
                validator: (v) =>
                v != _passwordController.text ? 'Passwords do not match' : null,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Reset Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // Capture navigator & messenger before the async call
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    setState(() => _isLoading = true);
    try {
      await AuthService().confirmPasswordReset(
        widget.oobCode,
        _passwordController.text,
      );

      // Safe to show SnackBar and navigate
      messenger.showSnackBar(
        const SnackBar(content: Text('Password reset successful!')),
      );
      navigator.popUntil((route) => route.isFirst);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      messenger.showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }
}
