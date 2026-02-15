/// Application-wide color constants used for theming and UI elements.
/// 
/// This class defines all color values used throughout the application.
/// Colors are stored as 32-bit integer values in ARGB format for consistency
/// and can be easily converted to Flutter Color objects.
class AppColors {
  /// Primary brand color (Light Blue)
  /// Used for primary UI elements like buttons, links, and highlights
  static const int primary = 0xFF2196F3;

  /// Dark variant of primary color
  /// Used for pressed states and darker backgrounds
  static const int primaryDark = 0xFF1976D2;

  /// Accent color (Green)
  /// Used for secondary actions and highlights
  static const int accent = 0xFF4CAF50;

  /// Error color (Red)
  /// Used for error messages, warnings, and invalid inputs
  static const int error = 0xFFF44336;

  /// Warning color (Amber/Yellow)
  /// Used for warning messages and cautions
  static const int warning = 0xFFFFC107;

  /// Success color (Green)
  /// Used for success messages and positive feedback
  static const int success = 0xFF4CAF50;
}
