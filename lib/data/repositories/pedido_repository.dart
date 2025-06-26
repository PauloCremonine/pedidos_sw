import 'dart:convert';
import 'package:pedidos/core/auth_http_client.dart';
import '../models/pedido.dart';

class PedidoRepository {
  final AuthHttpClient client;
  final String _baseUrl = 'https://dev-techtest.swfast.com.br';

  PedidoRepository({required this.client});

  Future<List<Pedido>?> getPedidos() async {
    final url = Uri.parse('$_baseUrl/orders');
    final response = await client.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Pedido.fromJson(json)).toList();
    } else {
      return null;
    }
  }

  Future<void> createPedido({
    required String customerName,
    required String description,
  }) async {
    final url = Uri.parse('$_baseUrl/orders');
    final response = await client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'customername': customerName,
        'description': description,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(
        'Erro ao criar pedido: ${response.statusCode} - ${response.body}',
      );
    }
  }

  Future<void> finalizarPedido(String pedidoId) async {
    final url = Uri.parse('$_baseUrl/orders/$pedidoId/finish');
    final response = await client.put(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(
        'Erro ao finalizar pedido: ${response.statusCode} - ${response.body}',
      );
    }
  }
}
