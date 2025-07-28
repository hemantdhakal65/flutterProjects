import 'package:flutter/material.dart';
import '../models/auth_method.dart';
import '../services/auth_service.dart';
import '../widgets/custom_text_input.dart';
import '../widgets/date_picker_field.dart';
import '../widgets/otp_input_field.dart';
import '../utils/auth_validators.dart';
import '../models/user_model.dart';
import '../../core/routes/route_names.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController    = TextEditingController();
  final _phoneController    = TextEditingController();
  final _passwordController = TextEditingController();
  final _otpController      = TextEditingController();

  DateTime? _dob;
  AuthMethod _selectedMethod = AuthMethod.email;

  bool _isLoading  = false;
  bool _codeSent   = false;
  String? _verificationId;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate() || _dob == null) return;

    setState(() => _isLoading = true);
    try {
      if (_selectedMethod == AuthMethod.email) {
        // Email sign-up
        final user = await AuthService().registerWithEmail(
          _emailController.text.trim(),
          _passwordController.text,
        );

        if (user != null && mounted) {
          Navigator.pushReplacementNamed(
            context,
            RouteNames.userReason,
            arguments: UserModel(
              uid: user.uid,
              email: _emailController.text.trim(),
              username: _usernameController.text.trim(),
              dob: _dob,
              isAnonymous: false,
            ),
          );
        }
      } else {
        // Phone sign-up: send SMS code
        _verificationId = await AuthService()
            .verifyPhoneNumber(_phoneController.text.trim());

        if (mounted) {
          setState(() => _codeSent = true);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _verifyOTP() async {
    if (_otpController.text.length != 6) return;

    setState(() => _isLoading = true);
    try {
      final user = await AuthService().registerWithPhone(
        _phoneController.text.trim(),
        _passwordController.text,
        _verificationId!,
        _otpController.text,
      );

      if (user != null && mounted) {
        Navigator.pushReplacementNamed(
          context,
          RouteNames.userReason,
          arguments: UserModel(
            uid: user.uid,
            phone: _phoneController.text.trim(),
            username: _usernameController.text.trim(),
            dob: _dob,
            isAnonymous: false,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('OTP Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(children: [
                CustomTextInput(
                  controller: _usernameController,
                  label: 'Username',
                  validator: AuthValidators.usernameValidator,
                ),
                const SizedBox(height: 20),
                DatePickerField(
                  onDateSelected: (date) => _dob = date,
                  validator: AuthValidators.dobValidator,
                ),
                const SizedBox(height: 20),

                Row(children: [
                  Expanded(
                    child: RadioListTile<AuthMethod>(
                      title: const Text('Email'),
                      value: AuthMethod.email,
                      groupValue: _selectedMethod,
                      onChanged: (v) => setState(() => _selectedMethod = v!),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<AuthMethod>(
                      title: const Text('Phone'),
                      value: AuthMethod.phone,
                      groupValue: _selectedMethod,
                      onChanged: (v) => setState(() => _selectedMethod = v!),
                    ),
                  ),
                ]),

                const SizedBox(height: 20),
                if (_selectedMethod == AuthMethod.email) ...[
                  CustomTextInput(
                    controller: _emailController,
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    validator: AuthValidators.emailValidator,
                  ),
                ] else ...[
                  CustomTextInput(
                    controller: _phoneController,
                    label: 'Phone',
                    keyboardType: TextInputType.phone,
                    validator: AuthValidators.phoneValidator,
                  ),
                ],

                const SizedBox(height: 20),
                CustomTextInput(
                  controller: _passwordController,
                  label: 'Password',
                  obscureText: true,
                  validator: AuthValidators.passwordValidator,
                ),

                const SizedBox(height: 30),
                if (!_codeSent)
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submitForm,
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Sign Up'),
                  ),

                if (_codeSent) ...[
                  Text('Enter the 6‑digit code sent to ${_phoneController.text.trim()}'),
                  const SizedBox(height: 12),
                  OTPInputField(controller: _otpController),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _verifyOTP,
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Verify Code'),
                  ),
                ],
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
