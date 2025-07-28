import 'dart:math';
import 'package:flutter/material.dart';

class SnapchatFormatter {
  static Map<String, dynamic> format(String text) {
    final styles = [
      {
        'fontSize': 24.0,
        'fontWeight': FontWeight.bold,
        'color': const Color(0xFFFFFF00)
      },
      {
        'fontSize': 22.0,
        'fontWeight': FontWeight.bold,
        'color': const Color(0xFFFF0055)
      },
      {
        'fontSize': 20.0,
        'fontStyle': FontStyle.italic,
        'color': const Color(0xFF05FF00)
      },
    ];

    final randomStyle = styles[Random().nextInt(styles.length)];
    return {
      'text': text,
      'style': randomStyle,
    };
  }
}