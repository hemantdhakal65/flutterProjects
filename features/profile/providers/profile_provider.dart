import 'package:flutter/material.dart';

class ProfileProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  bool _isVolumeOn = true;
  String? _gender;
  String? _profileImageUrl;
  bool _isDarkMode = false;
  String? _name = "John Doe";
  final String _email = "john.doe@example.com";

  ThemeMode get themeMode => _themeMode;
  bool get isVolumeOn => _isVolumeOn;
  String? get gender => _gender;
  String? get profileImageUrl => _profileImageUrl;
  bool get isDarkMode => _isDarkMode;
  String? get name => _name;
  String get email => _email;

  void toggleTheme(bool isDark) {
    _isDarkMode = isDark;
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void toggleVolume() {
    _isVolumeOn = !_isVolumeOn;
    notifyListeners();
  }

  void setGender(String gender) {
    _gender = gender;
    notifyListeners();
  }

  Future<void> setProfileImage(String imagePath) async {
    // Simulate image upload
    await Future.delayed(const Duration(seconds: 1));
    _profileImageUrl = imagePath;
    notifyListeners();
  }

  Future<void> updateName(String newName) async {
    _name = newName;
    notifyListeners();
  }
}
