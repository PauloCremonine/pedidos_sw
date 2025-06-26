import 'package:flutter/material.dart';
import '../data/models/pedido.dart';
import '../data/repositories/pedido_repository.dart';

class PedidoViewModel extends ChangeNotifier {
  final PedidoRepository _repository;

  PedidoViewModel(this._repository);

  List<Pedido> _pedidos = [];
  List<Pedido> get pedidos => _pedidos;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> fetchPedidos() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _repository.getPedidos();
      if (result != null) {
        _pedidos = result;
      } else {
        _error = 'Erro ao carregar os pedidos.';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createPedido({
    required String customerName,
    required String description,
  }) async {
    await _repository.createPedido(
      customerName: customerName,
      description: description,
    );
    await fetchPedidos();
  }

  Future<void> finalizarPedido(String pedidoId) async {
    await _repository.finalizarPedido(pedidoId);
    await fetchPedidos();
  }
}
