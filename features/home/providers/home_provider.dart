import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/post_model.dart';
import '../services/home_service.dart';

class HomeProvider with ChangeNotifier {
  final HomeService _service = HomeService();
  List<Post> _posts = [];
  String _searchQuery = '';
  Position? _currentPosition;
  bool _isLoading = true;

  List<Post> get posts => _posts;
  String get searchQuery => _searchQuery;
  Position? get currentPosition => _currentPosition;
  bool get isLoading => _isLoading;

  HomeProvider() {
    _initLocation();
  }

  Future<void> _initLocation() async {
    try {
      _currentPosition = await Geolocator.getCurrentPosition(
        locationSettings:
        const LocationSettings(accuracy: LocationAccuracy.high),
      );
      await _loadPosts();
    } catch (e) {
      debugPrint("Location error: $e");
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadPosts() async {
    if (_currentPosition == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      const radius = 10.0;
      _posts = await _service
          .getNearbyPostsStream(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        radius,
      )
          .first;
    } catch (e) {
      debugPrint("Error loading posts: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  List<Post> get filteredPosts {
    if (_searchQuery.isEmpty) return _posts;
    final q = _searchQuery.toLowerCase();
    return _posts.where((post) {
      return post.title.toLowerCase().contains(q) ||
          post.description.toLowerCase().contains(q) ||
          post.category.toLowerCase().contains(q) ||
          post.userName.toLowerCase().contains(q);
    }).toList();
  }

  Future<void> createPost({
    required String title,
    required String description,
    required String category,
    required Map<String, dynamic> specifications,
  }) async {
    if (_currentPosition == null) return;

    await _service.createPost(
      title: title,
      description: description,
      category: category,
      specifications: specifications,
      latitude: _currentPosition!.latitude,
      longitude: _currentPosition!.longitude,
    );
    await _loadPosts();
  }

  Future<void> addComment(String postId, String content) async {
    await _service.addComment(postId, content);
    await _loadPosts();
  }

  Future<void> bookUser({
    required String postId,
    required String bookedUserId,
    required String category,
    required DateTime meetingTime,
  }) async {
    await _service.bookUser(
      postId: postId,
      bookedUserId: bookedUserId,
      category: category,
      meetingTime: meetingTime,
    );
  }

  Future<void> reactToPost(String postId, String reactionType) async {
    await _service.updateReaction(postId, reactionType);
    await _loadPosts();
  }
}
