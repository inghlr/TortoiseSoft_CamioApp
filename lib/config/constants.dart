// Archivo: lib/config/constants.dart
// Constantes de la aplicación

class AppConstants {
  // Timeout
  static const Duration socketConnectionTimeout = Duration(seconds: 10);
  static const Duration webrtcTimeout = Duration(seconds: 30);
  static const Duration reconnectDelay = Duration(seconds: 3);

  // Valores por defecto
  static const String defaultDeviceName = 'My Phone Camera';
  static const String defaultServerIp = '192.168.1.100';
  static const int defaultServerPort = 8080;
  static const bool defaultUseSecureConnection = true;

  // Límites
  static const int maxDeviceNameLength = 50;
  static const int maxPasswordLength = 100;
  static const int minServerPort = 1024;
  static const int maxServerPort = 65535;

  // WebRTC
  static const List<String> iceServers = [
    'stun:stun.l.google.com:19302',
    'stun:stun1.l.google.com:19302',
    'stun:stun2.l.google.com:19302',
  ];

  // Logs
  static const bool enableLogging = true;
  static const bool enableNetworkLogging = false;
}

class AppStrings {
  // Botones
  static const String buttonStart = 'Start';
  static const String buttonStop = 'Stop';
  static const String buttonSwitchCamera = 'Switch Camera';
  static const String buttonSave = 'Save Settings';
  static const String buttonCancel = 'Cancel';

  // Estados
  static const String statusReady = 'Ready';
  static const String statusStreaming = 'Streaming';
  static const String statusConnecting = 'Connecting...';
  static const String statusDisconnected = 'Disconnected';
  static const String statusError = 'Error';

  // Mensajes
  static const String messageStartingCamera = 'Starting camera...';
  static const String messageConnectingToServer = 'Connecting to server...';
  static const String messageStopping = 'Stopping...';
  static const String messageCameraSwitched = 'Camera switched';
  static const String messageSettingsSaved = 'Settings saved!';
  static const String messageConnectionFailed = 'Failed to connect to server';

  // Etiquetas
  static const String labelDeviceInformation = 'Device Information';
  static const String labelServerConnection = 'Server Connection';
  static const String labelCameraSettings = 'Camera Settings';
  static const String labelDeviceName = 'Device Name';
  static const String labelServerIp = 'Server IP';
  static const String labelPort = 'Port';
  static const String labelResolution = 'Resolution';
  static const String labelFrameRate = 'Frame Rate';
  static const String labelPassword = 'Password (Optional)';
  static const String labelSecureConnection = 'Use Secure Connection (HTTPS)';
}

class AppColors {
  static const int primary = 0xFF2196F3;
  static const int primaryDark = 0xFF1976D2;
  static const int accent = 0xFF4CAF50;
  static const int error = 0xFFF44336;
  static const int warning = 0xFFFFC107;
  static const int success = 0xFF4CAF50;
}

class AppDimensions {
  static const double paddingXSmall = 4.0;
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  static const double borderRadiusSmall = 4.0;
  static const double borderRadiusMedium = 8.0;
  static const double borderRadiusLarge = 12.0;

  static const double iconSizeSmall = 20.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 48.0;
  static const double iconSizeXLarge = 80.0;

  static const double fabSize = 56.0;
  static const double fabSizeMini = 40.0;
}
