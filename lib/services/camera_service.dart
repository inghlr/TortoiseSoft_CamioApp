import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/app_config.dart';

class CameraService {
  MediaStream? _localStream;
  RTCPeerConnection? _peerConnection;
  final RTCVideoRenderer localRenderer = RTCVideoRenderer();

  bool get isStreaming => _localStream != null;
  MediaStream? get localStream => _localStream;
  RTCPeerConnection? get peerConnection => _peerConnection;

  Future<void> initRenderer() async {
    await localRenderer.initialize();
  }

  Future<void> startCameraStream(
    CameraResolution resolution,
    int fps, {
    bool useFrontCamera = true,
  }) async {
    try {
      // Solicitar permisos de cámara y micrófono
      final cameraStatus = await Permission.camera.request();
      final audioStatus = await Permission.microphone.request();

      if (!cameraStatus.isGranted || !audioStatus.isGranted) {
        throw Exception('Camera or microphone permission denied');
      }

      // Detener stream anterior si existe
      await stopCameraStream();

      final Map<String, dynamic> mediaConstraints = {
        'audio': false,
        'video': {
          'facingMode': useFrontCamera ? 'user' : 'environment',
          'width': {'ideal': resolution.width},
          'height': {'ideal': resolution.height},
          'frameRate': {'ideal': fps},
        }
      };

      _localStream =
          await navigator.mediaDevices.getUserMedia(mediaConstraints);
      localRenderer.srcObject = _localStream;

      // Configuración de PeerConnection
      final configuration = {
        'iceServers': [
          {'urls': 'stun:stun.l.google.com:19302'},
          {'urls': 'stun:stun1.l.google.com:19302'},
        ]
      };

      _peerConnection = await createPeerConnection(configuration);

      // Añadir el stream local
      _localStream?.getTracks().forEach((track) {
        _peerConnection?.addTrack(track, _localStream!);
      });
    } catch (e) {
      print('Error starting camera stream: $e');
      rethrow;
    }
  }

  Future<void> stopCameraStream() async {
    _localStream?.getTracks().forEach((track) {
      track.stop();
    });
    await _peerConnection?.close();
    _localStream = null;
    _peerConnection = null;
  }

  Future<void> switchCamera() async {
    final videoTrack = _localStream?.getVideoTracks().first;
    if (videoTrack != null) {
      await Helper.switchCamera(videoTrack);
    }
  }

  Future<void> dispose() async {
    await stopCameraStream();
    await localRenderer.dispose();
  }
}
