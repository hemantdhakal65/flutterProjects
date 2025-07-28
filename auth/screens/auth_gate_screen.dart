import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bookme/core/routes/route_names.dart';

class AuthGateScreen extends StatefulWidget {
  const AuthGateScreen({super.key});

  @override
  State<AuthGateScreen> createState() => _AuthGateScreenState();
}

class _AuthGateScreenState extends State<AuthGateScreen> {
  bool _redirectCalled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    if (_redirectCalled) return;
    _redirectCalled = true;

    try {
      // Wait for Firebase to initialize
      await Future.delayed(const Duration(milliseconds: 300));

      final user = FirebaseAuth.instance.currentUser;
      if (!mounted) return;

      if (user != null) {
        Navigator.pushReplacementNamed(context, RouteNames.mainNav);
      } else {
        Navigator.pushReplacementNamed(context, RouteNames.login);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Auth check failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}