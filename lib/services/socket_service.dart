import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../models/app_config.dart';

class SocketService {
  late IO.Socket socket;
  bool _isInitialized = false;
  final StreamController<ConnectionStatus> statusController =
      StreamController<ConnectionStatus>.broadcast();

  Stream<ConnectionStatus> get connectionStatus => statusController.stream;

  bool get isConnected => _isInitialized && socket.connected;

  Future<bool> connect(
    AppConfig config,
    RTCPeerConnection? peerConnection,
  ) async {
    try {
      final protocol = config.useSecureConnection ? 'https' : 'http';
      final url = '$protocol://${config.serverIp}:${config.serverPort}';

      socket = IO.io(
        url,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .setReconnectionDelay(3000)
            .setReconnectionDelayMax(10000)
            .setReconnectionAttempts(5)
            .build(),
      );
      
      _isInitialized = true;

      socket.on('connect', (_) {
        print('Socket connected');
        _emitDeviceInfo(config);
        statusController.add(ConnectionStatus.connected);
      });

      socket.on('disconnect', (_) {
        print('Socket disconnected');
        statusController.add(ConnectionStatus.disconnected);
      });

      socket.on('webrtc_offer', (data) async {
        if (peerConnection != null) {
          try {
            final offer = RTCSessionDescription(
              data['sdp'] ?? '',
              data['type'] ?? 'offer',
            );
            await peerConnection.setRemoteDescription(offer);

            final answer = await peerConnection.createAnswer();
            await peerConnection.setLocalDescription(answer);

            socket.emit('webrtc_answer', {
              'sdp': answer.sdp,
              'type': answer.type,
            });
          } catch (e) {
            print('Error handling WebRTC offer: $e');
          }
        }
      });

      socket.on('ice_candidate', (data) {
        if (peerConnection != null && data != null) {
          try {
            final candidate = RTCIceCandidate(
              data['candidate'] ?? '',
              data['sdpMLineIndex'] ?? 0,
              data['sdpMid'] ?? '',
            );
            peerConnection.addCandidate(candidate);
          } catch (e) {
            print('Error adding ICE candidate: $e');
          }
        }
      });

      socket.on('error', (error) {
        print('Socket error: $error');
        statusController.add(ConnectionStatus.error);
      });

      return true;
    } catch (e) {
      print('Error connecting to socket: $e');
      statusController.add(ConnectionStatus.error);
      return false;
    }
  }

  void _emitDeviceInfo(AppConfig config) {
    if (_isInitialized) {
      socket.emit('device_info', {
        'name': config.deviceName,
        'type': 'camera',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
    }
  }

  Future<void> disconnect() async {
    if (_isInitialized) {
      socket.disconnect();
    }
    await statusController.close();
  }

  void emitIceCandidate(RTCIceCandidate candidate) {
    if (_isInitialized && isConnected) {
      socket.emit('ice_candidate', {
        'candidate': candidate.candidate,
        'sdpMLineIndex': candidate.sdpMLineIndex,
        'sdpMid': candidate.sdpMid,
      });
    }
  }
}

enum ConnectionStatus {
  disconnected,
  connecting,
  connected,
  error,
}
