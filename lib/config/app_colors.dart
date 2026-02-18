/// Application-wide color constants used for theming and UI elements.
/// 
/// This class defines all color values used throughout the application.
/// Colors are stored as 32-bit integer values in ARGB format for consistency
/// and can be easily converted to Flutter Color objects.
class AppColors {
  /// Palette: Alabaster Grey
  static const int alabasterGrey = 0xFFD8DBE2;

  /// Palette: Powder Blue
  static const int powderBlue = 0xFFA9BCD0;

  /// Palette: Pacific Blue
  static const int pacificBlue = 0xFF58A4B0;

  /// Palette: Charcoal Blue
  static const int charcoalBlue = 0xFF373F51;

  /// Palette: Carbon Black
  static const int carbonBlack = 0xFF1B1B1E;

  /// Primary brand color
  /// Used for primary UI elements like buttons, links, and highlights
  static const int primary = pacificBlue;

  /// Dark variant of primary color
  /// Used for pressed states and darker backgrounds
  static const int primaryDark = charcoalBlue;

  /// Accent color
  /// Used for secondary actions and highlights
  static const int accent = powderBlue;

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
  static const int lightBackground = alabasterGrey;

  /// Dark background color
  static const int darkBackground = carbonBlack;

  /// Neutral color for secondary elements
  static const int neutralGray = powderBlue;

  /// Dark color for text and icons
  static const int darkGray = charcoalBlue;
}
