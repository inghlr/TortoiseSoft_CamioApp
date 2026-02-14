import 'package:flutter/material.dart';
import '../models/app_config.dart';
import '../services/camera_service.dart';
import '../services/config_service.dart';
import '../services/socket_service.dart';

class CameraProvider extends ChangeNotifier {
  final CameraService cameraService;
  final ConfigService configService;
  final SocketService socketService;

  AppConfig _config = AppConfig();
  bool _isStreaming = false;
  String _statusMessage = 'Ready';
  bool _isLoading = false;

  AppConfig get config => _config;
  bool get isStreaming => _isStreaming;
  String get statusMessage => _statusMessage;
  bool get isLoading => _isLoading;

  CameraProvider({
    required this.cameraService,
    required this.configService,
    required this.socketService,
  });

  Future<void> initialize() async {
    try {
      _isLoading = true;
      notifyListeners();

      await cameraService.initRenderer();
      _config = await configService.getConfig();

      _statusMessage = 'Initialized';
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _statusMessage = 'Error: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> startStreaming() async {
    try {
      _isLoading = true;
      _statusMessage = 'Starting camera...';
      notifyListeners();

      final resolution = cameraResolutions[_config.selectedResolutionIndex];
      final fps = cameraFps[_config.selectedFpsIndex].fps;

      await cameraService.startCameraStream(resolution, fps);

      // Conectar a socket
      _statusMessage = 'Connecting to server...';
      notifyListeners();

      final connected =
          await socketService.connect(_config, cameraService.peerConnection);

      if (connected) {
        _isStreaming = true;
        _statusMessage = 'Streaming...';
      } else {
        _statusMessage = 'Failed to connect to server';
        await cameraService.stopCameraStream();
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _statusMessage = 'Error: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> stopStreaming() async {
    try {
      _isLoading = true;
      _statusMessage = 'Stopping...';
      notifyListeners();

      await socketService.disconnect();
      await cameraService.stopCameraStream();

      _isStreaming = false;
      _statusMessage = 'Ready';
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _statusMessage = 'Error: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> switchCamera() async {
    try {
      await cameraService.switchCamera();
      _statusMessage = 'Camera switched';
      notifyListeners();
    } catch (e) {
      _statusMessage = 'Error switching camera: $e';
      notifyListeners();
    }
  }

  void updateConfig(AppConfig newConfig) {
    _config = newConfig;
    configService.saveConfig(newConfig);
    notifyListeners();
  }

  void updateResolution(int index) {
    _config.selectedResolutionIndex = index;
    notifyListeners();
  }

  void updateFps(int index) {
    _config.selectedFpsIndex = index;
    notifyListeners();
  }

  @override
  void dispose() {
    socketService.statusController.close();
    super.dispose();
  }
}
