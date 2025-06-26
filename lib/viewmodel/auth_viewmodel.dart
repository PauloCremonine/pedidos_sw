import 'package:flutter/material.dart';
import '../data/repositories/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  AuthViewModel(this._authRepository);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _accessToken;
  String? get accessToken => _accessToken;

  String? _refreshToken;
  DateTime? _expiresAt;

  String? _error;
  String? get error => _error;

  bool _shouldLogout = false;
  bool get shouldLogout => _shouldLogout;

  bool get isLoggedIn {
    if (_accessToken == null || _expiresAt == null) return false;
    return DateTime.now().isBefore(_expiresAt!);
  }

  void resetLogoutFlag() {
    _shouldLogout = false;
    notifyListeners();
  }

  void forceLogout() {
    _shouldLogout = true;
    logout(); // limpa os tokens e notifica
  }

  void _triggerLogout() {
    _accessToken = null;
    _refreshToken = null;
    _expiresAt = null;
    _shouldLogout = true;
    notifyListeners();
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _authRepository.login(
        username: username,
        password: password,
      );
      if (result != null) {
        _accessToken = result.accessToken;
        _refreshToken = result.refreshToken;
        _expiresAt = DateTime.now().add(Duration(seconds: result.expiresIn));

        await _authRepository.saveTokens(result);
      }
    } catch (e) {
      _error = e.toString();
      _triggerLogout(); // login falhou
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> refreshToken() async {
    final rf = _refreshToken;
    if (rf == null) {
      _triggerLogout();
      return false;
    }

    try {
      final result = await _authRepository.refreshAccessToken(rf);
      if (result != null) {
        _accessToken = result.accessToken;
        _refreshToken = result.refreshToken;
        _expiresAt = DateTime.now().add(Duration(seconds: result.expiresIn));

        await _authRepository.saveTokens(result);
        return true;
      }
      return false;
    } catch (e) {
      _error = e.toString();
      _triggerLogout(); // falha ao renovar
      return false;
    }
  }

  Future<void> loadToken() async {
    final tokens = await _authRepository.getTokens();
    if (tokens != null) {
      _accessToken = tokens.accessToken;
      _refreshToken = tokens.refreshToken;
      _expiresAt = tokens.expiresAt;
    }
    notifyListeners();
  }

  Future<void> logout() async {
    await _authRepository.logout();
    _triggerLogout();
  }

  Future<String?> getValidAccessToken() async {
    if (_accessToken == null || _refreshToken == null || _expiresAt == null) {
      await loadToken();
      if (_accessToken == null || _refreshToken == null || _expiresAt == null) {
        _triggerLogout();
        return null;
      }
    }

    if (DateTime.now().isAfter(_expiresAt!)) {
      try {
        final result = await _authRepository.refreshAccessToken(_refreshToken!);
        if (result != null) {
          _accessToken = result.accessToken;
          _refreshToken = result.refreshToken;
          _expiresAt = DateTime.now().add(Duration(seconds: result.expiresIn));

          await _authRepository.saveTokens(result);
        } else {
          _accessToken = null;
        }
      } catch (_) {
        _triggerLogout(); // falha ao renovar
        _accessToken = null;
      } finally {
        notifyListeners();
      }
    }
    return _accessToken;
  }
}
