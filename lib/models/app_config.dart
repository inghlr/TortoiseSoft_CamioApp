/// Modelo para la configuración de la aplicación
class AppConfig {
  String serverIp;
  int serverPort;
  String deviceName;
  int selectedCameraIndex;
  int selectedResolutionIndex;
  int selectedFpsIndex;
  bool useSecureConnection;
  String? customPassword;

  AppConfig({
    this.serverIp = '192.168.1.100',
    this.serverPort = 5000,
    this.deviceName = 'My Phone Camera',
    this.selectedCameraIndex = 0,
    this.selectedResolutionIndex = 1, // 720p default
    this.selectedFpsIndex = 1, // 30fps default
    this.useSecureConnection = true,
    this.customPassword,
  });

  Map<String, dynamic> toJson() => {
    'serverIp': serverIp,
    'serverPort': serverPort,
    'deviceName': deviceName,
    'selectedCameraIndex': selectedCameraIndex,
    'selectedResolutionIndex': selectedResolutionIndex,
    'selectedFpsIndex': selectedFpsIndex,
    'useSecureConnection': useSecureConnection,
    'customPassword': customPassword,
  };

  factory AppConfig.fromJson(Map<String, dynamic> json) => AppConfig(
    serverIp: json['serverIp'] ?? '192.168.1.100',
    serverPort: json['serverPort'] ?? 8080,
    deviceName: json['deviceName'] ?? 'My Phone Camera',
    selectedCameraIndex: json['selectedCameraIndex'] ?? 0,
    selectedResolutionIndex: json['selectedResolutionIndex'] ?? 1,
    selectedFpsIndex: json['selectedFpsIndex'] ?? 1,
    useSecureConnection: json['useSecureConnection'] ?? true,
    customPassword: json['customPassword'],
  );
}

/// Modelo para resoluciones de cámara
class CameraResolution {
  final String name;
  final int width;
  final int height;

  CameraResolution({
    required this.name,
    required this.width,
    required this.height,
  });
}

/// Modelo para FPS
class CameraFps {
  final String label;
  final int fps;

  CameraFps({required this.label, required this.fps});
}

/// Modelos predefinidos
final cameraResolutions = [
  CameraResolution(name: 'QVGA (320x240)', width: 320, height: 240),
  CameraResolution(name: 'VGA (640x480)', width: 640, height: 480),
  CameraResolution(name: 'HD (1280x720)', width: 1280, height: 720),
  CameraResolution(name: 'Full HD (1920x1080)', width: 1920, height: 1080),
];

final cameraFps = [
  CameraFps(label: '15 FPS', fps: 15),
  CameraFps(label: '24 FPS', fps: 24),
  CameraFps(label: '30 FPS', fps: 30),
  CameraFps(label: '60 FPS', fps: 60),
];
