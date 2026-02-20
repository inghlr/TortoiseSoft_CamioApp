import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_constants.dart';
import '../models/auth_session.dart';
import '../models/register_request.dart';

class AuthService {
  static const String _sessionKey = 'auth_session';
  final http.Client _httpClient;
  SharedPreferences? _prefs;

  AuthService({http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<AuthSession?> getSavedSession() async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_sessionKey);
    if (jsonString == null || jsonString.isEmpty) {
      return null;
    }

    try {
      return AuthSession.fromJson(
        jsonDecode(jsonString) as Map<String, dynamic>,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> saveSession(AuthSession session) async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    await prefs.setString(_sessionKey, jsonEncode(session.toJson()));
  }

  Future<void> clearSession() async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
  }

  Future<AuthSession> loginWithCredentials({
    required String identifier,
    required String password,
  }) async {
    final response = await _httpClient.post(
      Uri.parse(ApiConstants.login),
      headers: _jsonHeaders,
      body: jsonEncode(<String, dynamic>{
        'identifier': identifier,
        'password': password,
      }),
    );

    return _parseSessionResponse(response, fallbackName: identifier);
  }

  Future<AuthSession> loginWithSocial({
    required String provider,
    String? accessToken,
  }) async {
    final response = await _httpClient.post(
      Uri.parse(ApiConstants.login),
      headers: _jsonHeaders,
      body: jsonEncode(<String, dynamic>{
        'provider': provider,
        // Placeholder token to keep flow functional until SDK OAuth is wired.
        'access_token': accessToken ?? 'pending_${provider}_token',
      }),
    );

    return _parseSessionResponse(response, fallbackName: provider);
  }

  Future<String> register(RegisterRequest request) async {
    final response = await _httpClient.post(
      Uri.parse(ApiConstants.register),
      headers: _jsonHeaders,
      body: jsonEncode(request.toJson()),
    );

    final body = _decodeBody(response);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(_extractMessage(body));
    }

    return (body['registration_id'] ??
            body['registrationId'] ??
            body['id'] ??
            '')
        .toString();
  }

  Future<void> requestOtp({required String registrationId}) async {
    final response = await _httpClient.post(
      Uri.parse(ApiConstants.otpRequest),
      headers: _jsonHeaders,
      body: jsonEncode(<String, dynamic>{'registration_id': registrationId}),
    );

    final body = _decodeBody(response);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(_extractMessage(body));
    }
  }

  Future<AuthSession> verifyOtp({
    required String registrationId,
    required String otp,
  }) async {
    final response = await _httpClient.post(
      Uri.parse(ApiConstants.otpVerify),
      headers: _jsonHeaders,
      body: jsonEncode(<String, dynamic>{
        'registration_id': registrationId,
        'otp': otp,
      }),
    );

    return _parseSessionResponse(response, fallbackName: 'New user');
  }

  Future<Map<String, dynamic>> getProfile({required String token}) async {
    final response = await _httpClient.get(
      Uri.parse(ApiConstants.profile),
      headers: <String, String>{
        ..._jsonHeaders,
        'Authorization': 'Bearer $token',
      },
    );

    final body = _decodeBody(response);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(_extractMessage(body));
    }
    return body;
  }

  AuthSession _parseSessionResponse(
    http.Response response, {
    required String fallbackName,
  }) {
    final body = _decodeBody(response);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(_extractMessage(body));
    }

    final data = body['data'] is Map<String, dynamic>
        ? body['data'] as Map<String, dynamic>
        : <String, dynamic>{};

    final token =
        (data['token'] ??
                body['token'] ??
                body['access_token'] ??
                data['access_token'] ??
                '')
            .toString();
    if (token.isEmpty) {
      throw const FormatException('Token not present in auth response');
    }

    final user = body['user'] is Map<String, dynamic>
        ? body['user'] as Map<String, dynamic>
        : <String, dynamic>{};

    final dataUserId = data['userId'] ?? data['user_id'];
    final dataEmail = data['email'] ?? data['username'];

    return AuthSession(
      token: token,
      userId: (dataUserId ?? body['user_id'] ?? user['id'] ?? 'unknown')
          .toString(),
      displayName:
          (user['name'] ??
                  dataEmail ??
                  body['name'] ??
                  body['email'] ??
                  fallbackName)
              .toString(),
      loginType:
          (body['login_type'] ??
                  data['login_type'] ??
                  body['provider'] ??
                  'password')
              .toString(),
    );
  }

  Map<String, dynamic> _decodeBody(http.Response response) {
    if (response.body.isEmpty) {
      return <String, dynamic>{};
    }

    final decoded = jsonDecode(response.body);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }

    return <String, dynamic>{};
  }

  String _extractMessage(Map<String, dynamic> body) {
    return (body['message'] ??
            body['error'] ??
            body['detail'] ??
            'Authentication request failed')
        .toString();
  }

  Map<String, String> get _jsonHeaders {
    return const <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }
}
