import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OTPInputField extends StatelessWidget {
  final TextEditingController controller;
  final int length;

  const OTPInputField({
    super.key,
    required this.controller,
    this.length = 6,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'OTP Code',
        border: OutlineInputBorder(),
        counterText: '',
      ),
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      maxLength: length,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(length),
      ],
      style: const TextStyle(fontSize: 24, letterSpacing: 24),
    );
  }
}
