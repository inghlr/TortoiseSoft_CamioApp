import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../config/app_colors.dart';
import '../models/register_request.dart';
import '../providers/auth_provider.dart';

enum AuthView { login, register, otp }

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _loginIdentifierController = TextEditingController();
  final _loginPasswordController = TextEditingController();
  final _registerNameController = TextEditingController();
  final _registerLastNameController = TextEditingController();
  final _registerCountryController = TextEditingController();
  final _registerPhoneController = TextEditingController();
  final _registerPasswordController = TextEditingController();
  final _otpController = TextEditingController();

  AuthView _currentView = AuthView.login;

  @override
  void dispose() {
    _loginIdentifierController.dispose();
    _loginPasswordController.dispose();
    _registerNameController.dispose();
    _registerLastNameController.dispose();
    _registerCountryController.dispose();
    _registerPhoneController.dispose();
    _registerPasswordController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        _maybeShowErrorToast(context, authProvider);
        if (authProvider.hasPendingOtpVerification &&
            _currentView != AuthView.otp) {
          _currentView = AuthView.otp;
        }

        return Scaffold(
          backgroundColor: Color(AppColors.lightBackground),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Caminout',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  color: Color(AppColors.charcoalBlue),
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _titleForView(_currentView),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 20),
                          if (_currentView == AuthView.login)
                            _buildLoginForm(context, authProvider),
                          if (_currentView == AuthView.register)
                            _buildRegisterForm(context, authProvider),
                          if (_currentView == AuthView.otp)
                            _buildOtpForm(context, authProvider),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoginForm(BuildContext context, AuthProvider authProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _loginIdentifierController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Email or Phone Number',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _loginPasswordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: authProvider.isLoading
              ? null
              : () => _submitLogin(context),
          child: authProvider.isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Sign In'),
        ),
        const SizedBox(height: 12),
        const Divider(),
        const SizedBox(height: 8),
        _SocialLoginButton(
          icon: Icons.apple,
          label: 'Continue with Apple',
          onPressed: authProvider.isLoading
              ? null
              : () => _submitSocialLogin(context, 'apple'),
        ),
        const SizedBox(height: 8),
        _SocialLoginButton(
          icon: Icons.g_mobiledata,
          label: 'Continue with Google',
          onPressed: authProvider.isLoading
              ? null
              : () => _submitSocialLogin(context, 'google'),
        ),
        const SizedBox(height: 8),
        _SocialLoginButton(
          icon: Icons.facebook,
          label: 'Continue with Facebook',
          onPressed: authProvider.isLoading
              ? null
              : () => _submitSocialLogin(context, 'facebook'),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: authProvider.isLoading
              ? null
              : () {
                  authProvider.clearError();
                  setState(() {
                    _currentView = AuthView.register;
                  });
                },
          child: const Text('Create an account'),
        ),
      ],
    );
  }

  Widget _buildRegisterForm(BuildContext context, AuthProvider authProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _registerNameController,
          decoration: const InputDecoration(
            labelText: 'Name',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _registerLastNameController,
          decoration: const InputDecoration(
            labelText: 'Lastname',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _registerCountryController,
          decoration: const InputDecoration(
            labelText: 'Country',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _registerPhoneController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'Phone Number',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _registerPasswordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: authProvider.isLoading
              ? null
              : () => _submitRegister(context),
          child: authProvider.isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Register and Send OTP'),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: authProvider.isLoading
              ? null
              : () {
                  authProvider.clearError();
                  setState(() {
                    _currentView = AuthView.login;
                  });
                },
          child: const Text('I already have an account'),
        ),
      ],
    );
  }

  Widget _buildOtpForm(BuildContext context, AuthProvider authProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Enter the OTP code sent to ${authProvider.pendingPhoneNumber ?? 'your phone'}.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _otpController,
          keyboardType: TextInputType.number,
          maxLength: 6,
          decoration: const InputDecoration(
            labelText: 'OTP',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: authProvider.isLoading ? null : () => _submitOtp(context),
          child: authProvider.isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Confirm OTP'),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: authProvider.isLoading
              ? null
              : () async {
                  final success = await authProvider.resendOtp();
                  if (!mounted) return;
                  if (success) {
                    _showSnackBar(context, 'OTP resent');
                  }
                },
          child: const Text('Resend OTP'),
        ),
        TextButton(
          onPressed: authProvider.isLoading
              ? null
              : () {
                  authProvider.clearError();
                  setState(() {
                    _currentView = AuthView.register;
                  });
                },
          child: const Text('Back to registration'),
        ),
      ],
    );
  }

  Future<void> _submitLogin(BuildContext context) async {
    final authProvider = context.read<AuthProvider>();
    final identifier = _loginIdentifierController.text.trim();
    final password = _loginPasswordController.text;

    if (!kDebugMode && (identifier.isEmpty || password.isEmpty)) {
      _showSnackBar(context, 'Email/Phone and password are required');
      return;
    }

    final success = await authProvider.login(
      identifier: identifier,
      password: password,
    );

    if (!mounted) return;
    if (success) {
      _showSnackBar(context, 'Signed in successfully');
    }
  }

  Future<void> _submitSocialLogin(BuildContext context, String provider) async {
    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.loginWithSocial(provider);

    if (!mounted) return;
    if (success) {
      _showSnackBar(context, 'Signed in with $provider');
    }
  }

  Future<void> _submitRegister(BuildContext context) async {
    final authProvider = context.read<AuthProvider>();
    final request = RegisterRequest(
      name: _registerNameController.text.trim(),
      lastName: _registerLastNameController.text.trim(),
      country: _registerCountryController.text.trim(),
      phoneNumber: _registerPhoneController.text.trim(),
      password: _registerPasswordController.text,
    );

    if (request.name.isEmpty ||
        request.lastName.isEmpty ||
        request.country.isEmpty ||
        request.phoneNumber.isEmpty ||
        request.password.isEmpty) {
      _showSnackBar(context, 'Complete all registration fields');
      return;
    }

    final success = await authProvider.register(request);

    if (!mounted) return;
    if (success) {
      setState(() {
        _currentView = AuthView.otp;
      });
      _showSnackBar(context, 'Registration created. Check your OTP');
    }
  }

  Future<void> _submitOtp(BuildContext context) async {
    final authProvider = context.read<AuthProvider>();
    final otp = _otpController.text.trim();
    if (otp.length < 4) {
      _showSnackBar(context, 'Invalid OTP');
      return;
    }

    final success = await authProvider.verifyOtp(otp);
    if (!mounted) return;
    if (success) {
      _showSnackBar(context, 'Account verified');
    }
  }

  String _titleForView(AuthView view) {
    switch (view) {
      case AuthView.login:
        return 'Sign in with email or phone number';
      case AuthView.register:
        return 'Create your account';
      case AuthView.otp:
        return 'OTP confirmation';
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _maybeShowErrorToast(BuildContext context, AuthProvider authProvider) {
    final message = authProvider.errorMessage;
    if (message == null || message.isEmpty) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showSnackBar(context, message);
      authProvider.clearError();
    });
  }
}

class _SocialLoginButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  const _SocialLoginButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
    );
  }
}
