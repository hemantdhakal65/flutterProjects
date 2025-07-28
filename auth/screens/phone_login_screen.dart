import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/custom_text_input.dart';
import '../../core/routes/route_names.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Phone Login')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextInput(
                controller: _phoneController,
                label: 'Phone Number',
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  if (value.length < 10) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _verifyPhone,
                child: const Text('Send Verification Code'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _verifyPhone() async {
    if (_formKey.currentState!.validate()) {
      try {
        await AuthService().verifyPhoneNumber(_phoneController.text);
        if (mounted) {
          Navigator.pushNamed(
            context,
            RouteNames.otpVerification,
            arguments: {'phone': _phoneController.text, 'isLogin': true},
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }
}