# Authentication Implementation

This document describes the authentication module added to the Flutter app.

## Scope implemented

- Login with `email or phone number + password`.
- Social login buttons for `Apple`, `Google`, and `Facebook`.
- User registration with basic fields:
  - `name`
  - `lastname`
  - `country`
  - `phone number`
  - `password`
- OTP confirmation after registration.
- Persistent session on device. User stays logged in until logout.

## API configuration

Base authentication URL is configurable in:

- `lib/config/app_constants.dart`

```dart
static const String url = 'https://api.caminout.com/login';
```

The auth service uses this URL and derives related endpoints:

- Login: `POST {url}`
- Register: `POST /register` (derived from `/login`)
- OTP request: `POST /register/otp`
- OTP verify: `POST /register/verify-otp`

Implementation:

- `lib/services/auth_service.dart`

## New architecture components

### Models

- `lib/models/auth_session.dart`
  - Stores `token`, `userId`, `displayName`, `loginType`.
- `lib/models/register_request.dart`
  - Payload model for registration data.

### Service

- `lib/services/auth_service.dart`
  - Sends auth requests using `http`.
  - Handles login, social login, register, OTP request, OTP verify.
  - Persists session with `SharedPreferences`.

### Provider

- `lib/providers/auth_provider.dart`
  - Global auth state (`isAuthenticated`, `isLoading`, `errorMessage`).
  - Startup session restore.
  - Login/register/OTP actions.
  - Logout and session cleanup.

### UI

- `lib/screens/auth_page.dart`
  - Login form (`email/phone + password`).
  - Social buttons (`Apple`, `Google`, `Facebook`).
  - Register form.
  - OTP validation form.

## App integration

Main app flow was updated in:

- `lib/main.dart`

Changes:

- Registers `AuthProvider` at app root.
- Introduces `RootPage`:
  - If auth is not initialized: loading state.
  - If no session: opens `AuthPage`.
  - If session exists: opens main app (`AppInitializer`).

## Logout behavior

Logout was added in:

- `lib/screens/settings_page.dart`

Behavior:

- Stops stream if active.
- Clears saved auth session.
- Returns to first route, which then shows login screen.

## Session persistence

Session is stored locally using:

- `SharedPreferences` key: `auth_session`

The app restores this session on startup and keeps user authenticated until `logout`.

## Dependency added

Added in `pubspec.yaml`:

```yaml
http: ^1.2.2
```

## Notes

- Social login is integrated at UI and API-call level.
- Provider token exchange is currently placeholder-based until native SDK OAuth integration is added:
  - `google_sign_in`
  - `sign_in_with_apple`
  - `flutter_facebook_auth`
- In `debug` mode, pressing `Sign In` continues to the app using a local debug session.
