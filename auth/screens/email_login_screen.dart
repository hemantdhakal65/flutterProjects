import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/custom_text_input.dart';
import '../../core/routes/route_names.dart';

class EmailLoginScreen extends StatefulWidget {
  const EmailLoginScreen({super.key});

  @override
  State<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Email Login')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextInput(
                controller: _emailController,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
                validator: (v) => (v == null || v.isEmpty) ? 'Please enter your email' : null,
              ),
              const SizedBox(height: 20),
              CustomTextInput(
                controller: _passwordController,
                label: 'Password',
                obscureText: true,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Please enter your password';
                  if (v.length < 6) return 'Password must be at least 6 characters';
                  return null;
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(onPressed: _login, child: const Text('Login')),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, RouteNames.forgotPassword),
                child: const Text('Forgot Password?'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      final user = await AuthService().loginWithEmail(
        _emailController.text,
        _passwordController.text,
      );
      if (!mounted) return;
      if (user != null) {
        Navigator.pushReplacementNamed(context, RouteNames.mainNav);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
