import 'package:flutter/material.dart';
import 'package:pedidos/data/models/pedido.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/pedido_viewmodel.dart';

class PedidoDetalhesScreen extends StatelessWidget {
  const PedidoDetalhesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pedido = ModalRoute.of(context)!.settings.arguments as Pedido;
    final vm = Provider.of<PedidoViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes do Pedido')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cliente:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                        Text(
                          pedido.customerName,
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Descrição:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                        Text(pedido.description),
                        const SizedBox(height: 12),
                        Text(
                          'Status:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                        Text(
                          pedido.finished ? 'Finalizado' : 'Em Andamento',
                          style: TextStyle(
                            color: pedido.finished
                                ? Colors.green
                                : Colors.orange,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              if (!pedido.finished)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.check),
                    label: const Text('Finalizar Pedido'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    onPressed: () async {
                      try {
                        await vm.finalizarPedido(pedido.id);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Pedido finalizado!')),
                          );
                          Navigator.pop(context); // Volta para a lista
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text('Erro: $e')));
                        }
                      }
                    },
                  ),
                ),
              if (pedido.finished)
                const Text(
                  'Este pedido já foi finalizado.',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
