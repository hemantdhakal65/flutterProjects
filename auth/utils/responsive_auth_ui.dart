import 'package:flutter/material.dart';

class ResponsiveAuthUI {
  static double getFormWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 600) {
      return 500;
    } else {
      return width * 0.9;
    }
  }

  static EdgeInsets getFormPadding(BuildContext context) {
    return EdgeInsets.symmetric(
      vertical: 20,
      horizontal: MediaQuery.of(context).size.width > 600 ? 40 : 20,
    );
  }

  static double getElementSpacing(BuildContext context) {
    return MediaQuery.of(context).size.height > 600 ? 20 : 10;
  }

  static Widget wrapWithBackground(Widget child) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue, Colors.purple],
        ),
      ),
      child: child,
    );
  }
}