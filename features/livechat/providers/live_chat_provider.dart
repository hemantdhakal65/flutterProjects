import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class LiveChatProvider with ChangeNotifier {
  String _callStatus = 'idle';
  Map<String, dynamic>? _matchedUser;
  MediaStream? _localStream;
  MediaStream? _remoteStream;
  int _callDuration = 0;
  List<Map<String, dynamic>> _ephemeralMessages = [];
  bool _shouldSaveChat = false;
  bool _isInitiator = false;

  // — Getters
  String get callStatus       => _callStatus;
  Map<String, dynamic>? get matchedUser     => _matchedUser;
  MediaStream?        get localStream       => _localStream;
  MediaStream?        get remoteStream      => _remoteStream;
  int                 get callDuration     => _callDuration;
  List<Map<String, dynamic>> get ephemeralMessages => _ephemeralMessages;
  bool                get shouldSaveChat   => _shouldSaveChat;
  bool                get isInitiator      => _isInitiator;

  // — Setters
  set callStatus(String status) {
    _callStatus = status;
    notifyListeners();
  }

  set matchedUser(Map<String, dynamic>? user) {
    _matchedUser = user;
    notifyListeners();
  }

  set localStream(MediaStream? stream) {
    _localStream = stream;
    notifyListeners();
  }

  set remoteStream(MediaStream? stream) {
    _remoteStream = stream;
    notifyListeners();
  }

  set isInitiator(bool value) {
    _isInitiator = value;
    notifyListeners();
  }

  // — Helpers
  void addEphemeralMessage(Map<String, dynamic> message) {
    _ephemeralMessages.add({
      ...message,
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'timestamp': DateTime.now(),
    });
    notifyListeners();
  }

  void clearEphemeralMessages() {
    _ephemeralMessages.clear();
    notifyListeners();
  }

  void setShouldSaveChat(bool value) {
    _shouldSaveChat = value;
    notifyListeners();
  }

  void incrementCallDuration() {
    _callDuration++;
    notifyListeners();
  }

  void reset() {
    _callStatus       = 'idle';
    _matchedUser      = null;
    _localStream?.dispose();
    _localStream      = null;
    _remoteStream?.dispose();
    _remoteStream     = null;
    _callDuration     = 0;
    _ephemeralMessages = [];
    _shouldSaveChat   = false;
    _isInitiator      = false;
    notifyListeners();
  }
}
