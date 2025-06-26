import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_token.dart';

class AuthRepository {
  final String _baseUrl = 'https://dev-techtest.swfast.com.br';
  final String _clientId = 'user';
  final String _scope = 'user offline_access';

  AuthRepository();

  Future<AuthToken?> login({
    required String username,
    required String password,
  }) async {
    final url = Uri.parse('$_baseUrl/connect/token');

    final body = {
      'grant_type': 'password',
      'client_id': _clientId,
      'username': username,
      'password': password,
      'scope': _scope,
    };

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      final token = AuthToken.fromJson(json.decode(response.body));
      await saveTokens(token);
      return token;
    } else {
      return null;
    }
  }

  Future<AuthToken?> refreshAccessToken(String refreshToken) async {
    final url = Uri.parse('$_baseUrl/connect/token');

    final body = {
      'grant_type': 'refresh_token',
      'client_id': _clientId,
      'refresh_token': refreshToken,
    };

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      final token = AuthToken.fromJson(json.decode(response.body));
      await saveTokens(token);
      return token;
    } else {
      return null;
    }
  }

  Future<void> saveTokens(AuthToken token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token.accessToken);
    await prefs.setString('refresh_token', token.refreshToken);
    await prefs.setString('expires_at', token.expiresAt.toIso8601String());
  }

  Future<AuthToken?> getTokens() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');
    final refreshToken = prefs.getString('refresh_token');
    final expiresAtStr = prefs.getString('expires_at');

    if (accessToken != null && refreshToken != null && expiresAtStr != null) {
      final expiresAt = DateTime.tryParse(expiresAtStr);
      if (expiresAt != null) {
        return AuthToken(
          accessToken: accessToken,
          refreshToken: refreshToken,
          expiresIn: 0,
          expiresAt: expiresAt,
        );
      }
    }
    return null;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
    await prefs.remove('expires_at');
  }
}
