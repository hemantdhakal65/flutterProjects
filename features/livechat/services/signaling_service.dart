import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SignalingService {
  final String serverUrl;
  late WebSocketChannel _channel;
  Function(Map<String, dynamic>)? onMessage;

  SignalingService({required this.serverUrl});

  Future<void> connect() async {
    _channel = WebSocketChannel.connect(Uri.parse(serverUrl));
    _channel.stream.listen(
          (data) {
        final msg = jsonDecode(data) as Map<String, dynamic>;
        if (onMessage != null) onMessage!(msg);
      },
      onError: (error) => debugPrint('Signaling error: $error'),
      onDone: () => debugPrint('Signaling connection closed'),
    );
  }

  void sendMessage(Map<String, dynamic> message) {
    if (_channel.closeCode == null) {
      _channel.sink.add(jsonEncode(message));
    }
  }

  void disconnect() => _channel.sink.close();

  void onIceCandidate(Map<String, dynamic> candidate) {
    sendMessage({
      'type': 'ice-candidate',
      'candidate': candidate,
    });
  }

  void onLocalDescription(Map<String, dynamic> description) {
    sendMessage({
      'type': 'description',
      'description': description,
    });
  }
}