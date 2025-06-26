import 'package:http/http.dart' as http;
import 'package:pedidos/viewmodel/auth_viewmodel.dart';

class AuthHttpClient extends http.BaseClient {
  final http.Client _inner = http.Client();
  final AuthViewModel authViewModel;

  AuthHttpClient({required this.authViewModel});

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final token = await authViewModel.getValidAccessToken();

    if (token == null) {
      // Apenas força o logout e retorna um response fake de erro
      authViewModel.forceLogout();
      return http.StreamedResponse(
        const Stream.empty(),
        401,
        reasonPhrase: 'Token inválido ou expirado',
      );
    }

    // Clona a requisição com token
    final streamedRequest = _cloneRequestWithToken(request, token);
    http.StreamedResponse response = await _inner.send(streamedRequest);

    // Se 401, tenta refresh
    if (response.statusCode == 401) {
      final refreshed = await authViewModel.refreshToken();

      if (refreshed) {
        final newToken = authViewModel.accessToken;
        if (newToken != null) {
          final retryRequest = _cloneRequestWithToken(request, newToken);
          response = await _inner.send(retryRequest);
        }
      } else {
        authViewModel.forceLogout();
      }
    }

    return response;
  }

  http.BaseRequest _cloneRequestWithToken(
    http.BaseRequest original,
    String token,
  ) {
    final newRequest = http.Request(original.method, original.url)
      ..headers.addAll(original.headers)
      ..headers['Authorization'] = 'Bearer $token';

    if (original is http.Request) {
      newRequest.bodyBytes = original.bodyBytes;
    }

    return newRequest;
  }
}
