import 'package:flutter/material.dart';
import '../widgets/auth_option_card.dart';
import '../services/auth_service.dart';
import '../../core/routes/route_names.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            AuthOptionCard(
              icon: Icons.email,
              title: 'Email/Password Login',
              onTap: () {
                Navigator.pushNamed(context, RouteNames.emailLogin);
              },
            ),
            const SizedBox(height: 20),
            AuthOptionCard(
              icon: Icons.phone,
              title: 'Phone Login',
              onTap: () {
                Navigator.pushNamed(context, RouteNames.phoneLogin);
              },
            ),
            const SizedBox(height: 20),
            AuthOptionCard(
              icon: Icons.person,
              title: 'Anonymous Login',
              onTap: _handleAnonymousLogin,
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, RouteNames.signup);
              },
              child: const Text('Create New Account'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, RouteNames.forgotPassword);
              },
              child: const Text('Forgot Password?'),
            ),
            if (_isLoading) ...[
              const SizedBox(height: 20),
              const CircularProgressIndicator(),
            ]
          ],
        ),
      ),
    );
  }

  Future<void> _handleAnonymousLogin() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final user = await AuthService().signInAnonymously();
      if (user != null && mounted) {
        Navigator.pushReplacementNamed(context, RouteNames.mainNav);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Guest login failed: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}