import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:provider/provider.dart';

import '../providers/live_chat_provider.dart';
import 'call_controls.dart';
import 'ephemeral_chat_window.dart';
import '../services/webrtc_service.dart';
import '../services/signaling_service.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({super.key});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  late Timer _timer;
  bool _showChat = false;
  bool _isMuted = false;
  bool _isCameraOff = false;
  late WebRTCService _webRTCService;
  SignalingService? _signalingService;

  @override
  void initState() {
    super.initState();
    final liveChatProvider = Provider.of<LiveChatProvider>(context, listen: false);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      liveChatProvider.incrementCallDuration();
    });

    _initWebRTC();
  }

  Future<void> _initWebRTC() async {
    final liveChatProvider = Provider.of<LiveChatProvider>(context, listen: false);

    try {
      _webRTCService = WebRTCService();
      await _webRTCService.initialize();
      await _webRTCService.initPeerConnection();

      final localStream = await _webRTCService.getLocalMedia();
      if (!mounted) return;
      liveChatProvider.localStream = localStream;

      _signalingService = SignalingService(serverUrl: 'wss://yoursignaling.server');
      await _signalingService!.connect();

      if (liveChatProvider.isInitiator) {
        final offer = await _webRTCService.createOffer();
        _signalingService!.onLocalDescription(offer.toMap());
      }

      _signalingService!.onMessage = (message) async {
        if (message['type'] == 'description') {
          final description = RTCSessionDescription(
            message['description']['sdp'],
            message['description']['type'],
          );
          await _webRTCService.setRemoteDescription(description);

          if (!liveChatProvider.isInitiator) {
            final answer = await _webRTCService.createAnswer();
            _signalingService!.onLocalDescription(answer.toMap());
          }
        } else if (message['type'] == 'ice-candidate') {
          final candidate = RTCIceCandidate(
            message['candidate']['candidate'],
            message['candidate']['sdpMid'],
            message['candidate']['sdpMLineIndex'],
          );
          await _webRTCService.addIceCandidate(candidate);
        }
      };
    } catch (e) {
      debugPrint('WebRTC init error: $e');
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _webRTCService.dispose();
    _signalingService?.disconnect();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      final audioTracks = _webRTCService.localRenderer.srcObject?.getAudioTracks();
      if (audioTracks != null && audioTracks.isNotEmpty) {
        audioTracks.first.enabled = !_isMuted;
      }
    });
  }

  void _toggleCamera() {
    setState(() {
      _isCameraOff = !_isCameraOff;
      final videoTracks = _webRTCService.localRenderer.srcObject?.getVideoTracks();
      if (videoTracks != null && videoTracks.isNotEmpty) {
        videoTracks.first.enabled = !_isCameraOff;
      }
    });
  }

  void _endCall() {
    final liveChatProvider = Provider.of<LiveChatProvider>(context, listen: false);
    liveChatProvider.callStatus = 'ended';
  }

  @override
  Widget build(BuildContext context) {
    final liveChatProvider = Provider.of<LiveChatProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          if (liveChatProvider.remoteStream != null)
            RTCVideoView(
              _webRTCService.remoteRenderer,
              objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
            )
          else
            Container(
              color: Colors.black,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: liveChatProvider.matchedUser?['image'] != null
                          ? NetworkImage(liveChatProvider.matchedUser!['image'])
                          : null,
                      child: liveChatProvider.matchedUser?['image'] == null
                          ? const Icon(Icons.person, size: 60, color: Colors.white)
                          : null,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      liveChatProvider.matchedUser?['name'] ?? 'Connecting...',
                      style: const TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ],
                ),
              ),
            ),

          Positioned(
            top: 40,
            right: 20,
            child: SizedBox(
              width: 120,
              height: 160,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: RTCVideoView(
                  _webRTCService.localRenderer,
                  mirror: true,
                  objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                ),
              ),
            ),
          ),

          Positioned(
            top: 40,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    liveChatProvider.matchedUser?['name'] ?? 'Unknown',
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    _formatTime(liveChatProvider.callDuration),
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),

          if (_showChat)
            Positioned(
              bottom: 180,
              left: 20,
              right: 20,
              child: EphemeralChatWindow(
                onClose: () => setState(() => _showChat = false),
              ),
            ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CallControls(
              onDecline: _endCall,
              onToggleMute: _toggleMute,
              onToggleCamera: _toggleCamera,
              isMuted: _isMuted,
              isCameraOff: _isCameraOff,
            ),
          ),

          Positioned(
            bottom: 180,
            right: 20,
            child: FloatingActionButton(
              onPressed: () => setState(() => _showChat = !_showChat),
              backgroundColor: Colors.black54,
              child: const Icon(Icons.chat, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
