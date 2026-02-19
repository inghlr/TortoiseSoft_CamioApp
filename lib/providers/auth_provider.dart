import 'package:flutter/foundation.dart';
import '../models/auth_session.dart';
import '../models/register_request.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService authService;

  AuthSession? _session;
  bool _isLoading = false;
  bool _isInitialized = false;
  String? _errorMessage;
  String? _pendingRegistrationId;
  String? _pendingPhoneNumber;

  AuthProvider({required this.authService});

  AuthSession? get session => _session;
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;
  bool get isAuthenticated => _session != null;
  String? get errorMessage => _errorMessage;
  String? get pendingPhoneNumber => _pendingPhoneNumber;
  bool get hasPendingOtpVerification => _pendingRegistrationId != null;

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      await authService.init();
      _session = await authService.getSavedSession();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<bool> login({
    required String identifier,
    required String password,
  }) async {
    return _runAuthAction(() async {
      final session = kDebugMode
          ? AuthSession(
              token: 'debug-token',
              userId: 'debug-user',
              displayName: identifier.isEmpty ? 'Debug User' : identifier,
              loginType: 'debug',
            )
          : await authService.loginWithCredentials(
              identifier: identifier,
              password: password,
            );
      _session = session;
      await authService.saveSession(session);
      _pendingRegistrationId = null;
      _pendingPhoneNumber = null;
    });
  }

  Future<bool> loginWithSocial(String provider) async {
    return _runAuthAction(() async {
      final session = await authService.loginWithSocial(provider: provider);
      _session = session;
      await authService.saveSession(session);
      _pendingRegistrationId = null;
      _pendingPhoneNumber = null;
    });
  }

  Future<bool> register(RegisterRequest request) async {
    return _runAuthAction(() async {
      final registrationId = await authService.register(request);
      if (registrationId.isEmpty) {
        throw Exception('No registration id returned by API');
      }
      _pendingRegistrationId = registrationId;
      _pendingPhoneNumber = request.phoneNumber;
      await authService.requestOtp(registrationId: registrationId);
    });
  }

  Future<bool> resendOtp() async {
    final registrationId = _pendingRegistrationId;
    if (registrationId == null) {
      _errorMessage = 'No pending registration found';
      notifyListeners();
      return false;
    }

    return _runAuthAction(() async {
      await authService.requestOtp(registrationId: registrationId);
    });
  }

  Future<bool> verifyOtp(String otp) async {
    final registrationId = _pendingRegistrationId;
    if (registrationId == null) {
      _errorMessage = 'No pending registration found';
      notifyListeners();
      return false;
    }

    return _runAuthAction(() async {
      final session = await authService.verifyOtp(
        registrationId: registrationId,
        otp: otp,
      );
      _session = session;
      await authService.saveSession(session);
      _pendingRegistrationId = null;
      _pendingPhoneNumber = null;
    });
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await authService.clearSession();
      _session = null;
      _errorMessage = null;
      _pendingRegistrationId = null;
      _pendingPhoneNumber = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> _runAuthAction(Future<void> Function() action) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await action();
      return true;
    } catch (e) {
      _errorMessage = _normalizeError(e);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String _normalizeError(Object error) {
    final raw = error.toString();
    if (raw.startsWith('Exception: ')) {
      return raw.substring('Exception: '.length);
    }
    return raw;
  }
}
