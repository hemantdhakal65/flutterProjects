import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/otp_input_field.dart';
import '../../core/routes/route_names.dart';
import '../models/user_model.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String phone;
  final String? username;
  final DateTime? dob;
  final String? password;
  final bool isLogin;

  const OTPVerificationScreen({
    super.key,
    required this.phone,
    this.username,
    this.dob,
    this.password,
    this.isLogin = false,
  });

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final _otpController = TextEditingController();
  String? _verificationId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _verifyPhoneNumber();
  }

  Future<void> _verifyPhoneNumber() async {
    setState(() => _isLoading = true);
    try {
      _verificationId = await AuthService().getVerificationId(widget.phone);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _verifyOTP() async {
    if (_otpController.text.length != 6) return;
    setState(() => _isLoading = true);

    try {
      if (widget.isLogin) {
        final user = await AuthService().loginWithPhone(
          _verificationId!,
          _otpController.text,
        );
        if (mounted && user != null) {
          Navigator.pushReplacementNamed(context, RouteNames.mainNav);
        }
      } else {
        final user = await AuthService().registerWithPhone(
          widget.phone,
          widget.password!,
          _verificationId!,
          _otpController.text,
        );
        if (mounted && user != null) {
          Navigator.pushReplacementNamed(
            context,
            RouteNames.userReason,
            arguments: UserModel(
              uid: user.uid,
              phone: widget.phone,
              username: widget.username,
              dob: widget.dob,
              isAnonymous: false,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text('Enter OTP sent to ${widget.phone}'),
            const SizedBox(height: 20),
            OTPInputField(controller: _otpController),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(onPressed: _verifyOTP, child: const Text('Verify')),
            const SizedBox(height: 20),
            TextButton(
              onPressed: _verifyPhoneNumber,
              child: const Text('Resend Code'),
            ),
          ],
        ),
      ),
    );
  }
}
