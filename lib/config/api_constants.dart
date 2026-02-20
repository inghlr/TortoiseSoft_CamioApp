/// API endpoints and domain configuration (mutable at runtime via .env).
/// Call [setDomain] during app startup after loading EnvService.
class ApiConstants {
  static String domain = 'localhost:3000';
  static String baseUrl = 'http://$domain';

  static String register = '$baseUrl/api/auth/register';
  static String login = '$baseUrl/api/auth/login';
  static String profile = '$baseUrl/api/auth/profile';
  static String otpRequest = '$baseUrl/api/auth/otp/request';
  static String otpVerify = '$baseUrl/api/auth/otp/verify';

  /// Updates all URLs when domain changes.
  static void setDomain(String newDomain) {
    domain = newDomain.isNotEmpty ? newDomain : domain;
    baseUrl = 'http://$domain';
    register = '$baseUrl/api/auth/register';
    login = '$baseUrl/api/auth/login';
    profile = '$baseUrl/api/auth/profile';
    otpRequest = '$baseUrl/api/auth/otp/request';
    otpVerify = '$baseUrl/api/auth/otp/verify';
  }
}
