/// Application-wide constants for timeouts, defaults, limits, and WebRTC configuration.
///
/// This class contains all the constant values used throughout the application,
/// including socket connection timeouts, default configuration values,
/// port limits, and STUN servers for WebRTC connectivity.
class AppConstants {
  // Timeout durations
  /// Socket connection timeout duration (10 seconds)
  static const Duration socketConnectionTimeout = Duration(seconds: 10);

  /// WebRTC connection timeout duration (30 seconds)
  static const Duration webrtcTimeout = Duration(seconds: 30);

  /// Delay before attempting to reconnect (3 seconds)
  static const Duration reconnectDelay = Duration(seconds: 3);

  // Default values
  /// Default device name used when no custom name is provided
  static const String defaultDeviceName = 'My Phone Camera';

  /// Default server IP address (192.168.1.100)
  static const String defaultServerIp = '192.168.1.100';

  /// Default server port (8080)
  static const int defaultServerPort = 8080;

  /// Default secure connection setting (HTTPS/WSS enabled)
  static const bool defaultUseSecureConnection = true;

  // Validation limits
  /// Maximum length for device name input
  static const int maxDeviceNameLength = 50;

  /// Maximum length for password input
  static const int maxPasswordLength = 100;

  /// Minimum valid server port number
  static const int minServerPort = 1024;

  /// Maximum valid server port number
  static const int maxServerPort = 65535;

  // WebRTC configuration
  /// List of STUN servers used for NAT traversal and ICE candidate discovery
  static const List<String> iceServers = [
    'stun:stun.l.google.com:19302',
    'stun:stun1.l.google.com:19302',
    'stun:stun2.l.google.com:19302',
  ];

  // Logging configuration
  /// Enable debug logging throughout the application
  static const bool enableLogging = true;

  /// Enable detailed network request and response logging
  static const bool enableNetworkLogging = false;
}
