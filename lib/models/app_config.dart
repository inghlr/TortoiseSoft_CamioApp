import 'enum/camera_type.dart';
import 'enum/resolution_type.dart';
import 'enum/fps_type.dart';

/// Modelo para la configuración de la aplicación
class AppConfig {
  String serverIp;
  int serverPort;
  String deviceName;
  CameraType selectedCamera;
  ResolutionType selectedResolution;
  FpsType selectedFps;
  bool useSecureConnection;
  String? customPassword;

  AppConfig({
    this.serverIp = '192.168.1.100',
    this.serverPort = 5000,
    this.deviceName = 'My Phone Camera',
    this.selectedCamera = CameraType.front,
    this.selectedResolution = ResolutionType.hd,
    this.selectedFps = FpsType.fps30,
    this.useSecureConnection = true,
    this.customPassword,
  });

  Map<String, dynamic> toJson() => {
    'serverIp': serverIp,
    'serverPort': serverPort,
    'deviceName': deviceName,
    'selectedCamera': selectedCamera.value,
    'selectedResolution': selectedResolution.index,
    'selectedFps': selectedFps.index,
    'useSecureConnection': useSecureConnection,
    'customPassword': customPassword,
  };

  factory AppConfig.fromJson(Map<String, dynamic> json) => AppConfig(
    serverIp: json['serverIp'] ?? '192.168.1.100',
    serverPort: json['serverPort'] ?? 5000,
    deviceName: json['deviceName'] ?? 'My Phone Camera',
    selectedCamera: CameraType.fromString(json['selectedCamera'] ?? 'front'),
    selectedResolution: ResolutionType.fromIndex(json['selectedResolution'] ?? 2),
    selectedFps: FpsType.fromIndex(json['selectedFps'] ?? 2),
    useSecureConnection: json['useSecureConnection'] ?? true,
    customPassword: json['customPassword'],
  );
}