/// API endpoints and domain configuration.
/// Keeps all URLs centralized and separated from other app constants.
class ApiConstants {
  /// Base domain for the API (host:port).
  static const String domain = 'localhost:3000';

  /// Base URL built from domain. Adjust scheme if your API requires HTTPS.
  static const String baseUrl = 'http://$domain';

  /// Authentication endpoints.
  static const String register = '$baseUrl/api/auth/register';
  static const String login = '$baseUrl/api/auth/login';
  static const String profile = '$baseUrl/api/auth/profile';

  /// OTP endpoints (used by the registration flow).
  static const String otpRequest = '$baseUrl/api/auth/otp/request';
  static const String otpVerify = '$baseUrl/api/auth/otp/verify';
}
