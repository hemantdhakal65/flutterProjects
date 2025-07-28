import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../models/user_model.dart';
import '../services/category_service.dart';

class CategoryProvider with ChangeNotifier {
  List<Category> _allCategories = [];
  List<Category> _filteredCategories = [];
  String _searchQuery = '';
  List<User> _filteredUsers = [];
  Category? _selectedCategory;
  double _maxDistance = 10.0; // in km
  final List<String> _genderFilters = []; // Made final
  bool _onlineOnly = true;

  CategoryProvider() {
    _loadCategories();
  }

  void _loadCategories() {
    _allCategories = CategoryService.getCategories();
    _filteredCategories = _allCategories;
    notifyListeners();
  }

  List<Category> get filteredCategories => _filteredCategories;
  List<User> get filteredUsers => _filteredUsers;
  Category? get selectedCategory => _selectedCategory;
  double get maxDistance => _maxDistance;
  List<String> get genderFilters => _genderFilters;
  bool get onlineOnly => _onlineOnly;

  void setSearchQuery(String query) {
    _searchQuery = query;
    _filterCategories();
    notifyListeners();
  }

  void setSelectedCategory(Category category) {
    _selectedCategory = category;
    _filterUsers();
    notifyListeners();
  }

  void setMaxDistance(double distance) {
    _maxDistance = distance;
    _filterUsers();
    notifyListeners();
  }

  void toggleGenderFilter(String gender) {
    if (_genderFilters.contains(gender)) {
      _genderFilters.remove(gender);
    } else {
      _genderFilters.add(gender);
    }
    _filterUsers();
    notifyListeners();
  }

  void setOnlineOnly(bool value) {
    _onlineOnly = value;
    _filterUsers();
    notifyListeners();
  }

  void _filterCategories() {
    if (_searchQuery.isEmpty) {
      _filteredCategories = _allCategories;
    } else {
      _filteredCategories = _allCategories
          .where((category) =>
      category.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          category.description.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
  }

  void _filterUsers() {
    if (_selectedCategory == null) return;

    List<User> allUsers = CategoryService.getUsersForCategory(_selectedCategory!.id);

    _filteredUsers = allUsers.where((user) {
      // Distance filter
      if (user.distance > _maxDistance) return false;

      // Gender filter
      if (_genderFilters.isNotEmpty && !_genderFilters.contains(user.gender)) {
        return false;
      }

      // Online status filter
      if (_onlineOnly && !user.isOnline) return false;

      return true;
    }).toList();
  }
}