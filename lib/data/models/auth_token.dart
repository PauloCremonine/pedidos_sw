class AuthToken {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;
  final DateTime expiresAt;

  AuthToken({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.expiresAt,
  });

  factory AuthToken.fromJson(Map<String, dynamic> json) {
    final accessToken = json['access_token'];
    final refreshToken = json['refresh_token'] ?? '';
    final expiresIn = json['expires_in'] ?? 3600;
    final expiresAt = DateTime.now().add(Duration(seconds: expiresIn));

    return AuthToken(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresIn: expiresIn,
      expiresAt: expiresAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'expires_in': expiresIn,
      'expires_at': expiresAt.toIso8601String(),
    };
  }
}
