import 'package:flutter/material.dart';
import '../models/app_config.dart';
import '../models/enum/resolution_type.dart';
import '../models/enum/fps_type.dart';
import '../services/camera_service.dart';
import '../services/config_service.dart';
import '../services/socket_service.dart';
import '../services/network_service.dart';

class CameraProvider extends ChangeNotifier {
  final CameraService cameraService;
  final ConfigService configService;
  final SocketService socketService;
  final NetworkService networkService = NetworkService();

  AppConfig _config = AppConfig();
  bool _isStreaming = false;
  String _statusMessage = 'Ready';
  bool _isLoading = false;
  String _localIp = 'Loading...';

  AppConfig get config => _config;
  bool get isStreaming => _isStreaming;
  String get statusMessage => _statusMessage;
  bool get isLoading => _isLoading;
  String get localIp => _localIp;

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

      // Obtener la IP local del dispositivo
      _localIp = await networkService.getLocalIp();

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

      final width = _config.selectedResolution.width;
      final height = _config.selectedResolution.height;
      final fps = _config.selectedFps.fps;

      await cameraService.startCameraStream(width, height, fps);

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

  void updateResolution(ResolutionType resolution) {
    _config.selectedResolution = resolution;
    notifyListeners();
  }

  void updateFps(FpsType fps) {
    _config.selectedFps = fps;
    notifyListeners();
  }

  @override
  void dispose() {
    socketService.statusController.close();
    super.dispose();
  }
}
