class AuthSession {
  final String token;
  final String userId;
  final String displayName;
  final String loginType;

  const AuthSession({
    required this.token,
    required this.userId,
    required this.displayName,
    required this.loginType,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'token': token,
      'userId': userId,
      'displayName': displayName,
      'loginType': loginType,
    };
  }

  factory AuthSession.fromJson(Map<String, dynamic> json) {
    return AuthSession(
      token: (json['token'] ?? '').toString(),
      userId: (json['userId'] ?? '').toString(),
      displayName: (json['displayName'] ?? '').toString(),
      loginType: (json['loginType'] ?? 'password').toString(),
    );
  }
}
