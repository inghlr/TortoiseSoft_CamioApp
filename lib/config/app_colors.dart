/// Application-wide color constants used for theming and UI elements.
/// 
/// This class defines all color values used throughout the application.
/// Colors are stored as 32-bit integer values in ARGB format for consistency
/// and can be easily converted to Flutter Color objects.
class AppColors {
  /// Primary brand color (Cyan/Turquoise)
  /// Used for primary UI elements like buttons, links, and highlights
  static const int primary = 0xFF00BCD4;

  /// Dark variant of primary color
  /// Used for pressed states and darker backgrounds
  static const int primaryDark = 0xFF00838F;

  /// Accent color (Light Cyan)
  /// Used for secondary actions and highlights
  static const int accent = 0xFFB2EBF2;

  /// Error color (Red)
  /// Used for error messages, warnings, and invalid inputs
  static const int error = 0xFFE53935;

  /// Warning color (Orange)
  /// Used for warning messages and cautions
  static const int warning = 0xFFFB8C00;

  /// Success color (Teal)
  /// Used for success messages and positive feedback
  static const int success = 0xFF00796B;

  /// Light background color
  static const int lightBackground = 0xFFF5F5F5;

  /// Dark background color
  static const int darkBackground = 0xFF1A1A1A;

  /// Neutral gray for secondary elements
  static const int neutralGray = 0xFF9E9E9E;

  /// Dark gray for text and icons
  static const int darkGray = 0xFF424242;
}
