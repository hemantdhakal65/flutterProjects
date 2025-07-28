import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../services/signaling_service.dart';  // make sure this path is correct

class WebRTCService {
  RTCPeerConnection? _peerConnection;
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  MediaStream? _localStream;
  SignalingService? _signalingService;

  RTCVideoRenderer get localRenderer => _localRenderer;
  RTCVideoRenderer get remoteRenderer => _remoteRenderer;

  /// Call this first to initialize the renderers.
  Future<void> initialize() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  /// Inject your SignalingService before creating the peer connection:
  void setSignalingService(SignalingService signaling) {
    _signalingService = signaling;
  }

  /// Creates the RTCPeerConnection and wires up ICE/track callbacks.
  Future<void> initPeerConnection() async {
    _peerConnection = await createPeerConnection(
      {
        'iceServers': [
          {'urls': 'stun:stun.l.google.com:19302'},
        ],
      },
      {},
    );

    _peerConnection!.onIceCandidate = (RTCIceCandidate? candidate) {
      if (candidate != null && _signalingService != null) {
        // <-- use your onIceCandidate helper
        _signalingService!.onIceCandidate(candidate.toMap());
      }
    };

    _peerConnection!.onTrack = (RTCTrackEvent event) {
      if (event.track.kind == 'video' && event.streams.isNotEmpty) {
        _remoteRenderer.srcObject = event.streams.first;
      }
    };
  }

  /// Grab user media and render locally.
  Future<MediaStream> getLocalMedia() async {
    _localStream = await navigator.mediaDevices.getUserMedia({
      'audio': true,
      'video': {
        'facingMode': 'user',
        'width': 1280,
        'height': 720,
        'frameRate': 30,
      },
    });
    _localRenderer.srcObject = _localStream;
    return _localStream!;
  }

  Future<RTCSessionDescription> createOffer() async {
    final offer = await _peerConnection!.createOffer();
    await _peerConnection!.setLocalDescription(offer);
    return offer;
  }

  Future<void> setRemoteDescription(RTCSessionDescription desc) async {
    await _peerConnection!.setRemoteDescription(desc);
  }

  Future<RTCSessionDescription> createAnswer() async {
    final answer = await _peerConnection!.createAnswer();
    await _peerConnection!.setLocalDescription(answer);
    return answer;
  }

  Future<void> addIceCandidate(RTCIceCandidate candidate) async {
    await _peerConnection!.addCandidate(candidate);
  }

  /// Fully close down media & connection.
  Future<void> close() async {
    await _peerConnection?.close();
    _localRenderer.srcObject = null;
    _remoteRenderer.srcObject = null;
    await _localStream?.dispose();
  }

  /// Dispose of renderers and connection.
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    _peerConnection?.close();
  }
}
