/// Application-wide string constants for UI labels, buttons, messages, and status texts.
/// 
/// This class centralizes all hardcoded strings used in the user interface,
/// making it easy to maintain, translate, or modify UI text throughout the application.
/// Strings are organized by category: buttons, status messages, user feedback, and labels.
class AppStrings {
  // Button labels
  /// Label for the "Start" button
  static const String buttonStart = 'Start';

  /// Label for the "Stop" button
  static const String buttonStop = 'Stop';

  /// Label for the "Switch Camera" button
  static const String buttonSwitchCamera = 'Switch Camera';

  /// Label for the "Save Settings" button
  static const String buttonSave = 'Save Settings';

  /// Label for the "Cancel" button
  static const String buttonCancel = 'Cancel';

  // Status messages
  /// Status text indicating the application is ready
  static const String statusReady = 'Ready';

  /// Status text indicating active streaming
  static const String statusStreaming = 'Streaming';

  /// Status text indicating connection attempt in progress
  static const String statusConnecting = 'Connecting...';

  /// Status text indicating no active connection
  static const String statusDisconnected = 'Disconnected';

  /// Status text indicating an error condition
  static const String statusError = 'Error';

  // User feedback messages
  /// Message shown when starting the camera
  static const String messageStartingCamera = 'Starting camera...';

  /// Message shown when connecting to the server
  static const String messageConnectingToServer = 'Connecting to server...';

  /// Message shown when stopping the stream
  static const String messageStopping = 'Stopping...';

  /// Message shown when camera is successfully switched
  static const String messageCameraSwitched = 'Camera switched';

  /// Message shown when settings are successfully saved
  static const String messageSettingsSaved = 'Settings saved!';

  /// Error message when server connection fails
  static const String messageConnectionFailed = 'Failed to connect to server';

  // Form labels and section titles
  /// Section title for device information form
  static const String labelDeviceInformation = 'Device Information';

  /// Section title for server connection settings
  static const String labelServerConnection = 'Server Connection';

  /// Section title for camera-related settings
  static const String labelCameraSettings = 'Camera Settings';

  /// Label for device name input field
  static const String labelDeviceName = 'Device Name';

  /// Label for server IP address input field
  static const String labelServerIp = 'Server IP';

  /// Label for server port input field
  static const String labelPort = 'Port';

  /// Label for video resolution selection
  static const String labelResolution = 'Resolution';

  /// Label for frame rate (FPS) selection
  static const String labelFrameRate = 'Frame Rate';

  /// Label for optional password input field
  static const String labelPassword = 'Password (Optional)';

  /// Label for secure connection toggle
  static const String labelSecureConnection = 'Use Secure Connection (HTTPS)';
}
