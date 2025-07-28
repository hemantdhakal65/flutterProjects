import 'package:flutter/material.dart';

class DeclineButton extends StatelessWidget {
  final VoidCallback onDecline;
  final double size;

  const DeclineButton({
    super.key,
    required this.onDecline,
    this.size = 60,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDecline,
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              spreadRadius: 2,
            )
          ],
        ),
        child: const Icon(
          Icons.close,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}