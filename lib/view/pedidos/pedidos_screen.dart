import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/pedido_viewmodel.dart';
import '../../viewmodel/auth_viewmodel.dart';

class PedidosScreen extends StatefulWidget {
  const PedidosScreen({super.key});

  @override
  State<PedidosScreen> createState() => _PedidosScreenState();
}

class _PedidosScreenState extends State<PedidosScreen> {
  @override
  void initState() {
    super.initState();

    // Evita uso de context fora do ciclo de vida do widget
    Future.microtask(() async {
      if (!mounted) return;
      final authVM = Provider.of<AuthViewModel>(context, listen: false);
      final pedidoVM = Provider.of<PedidoViewModel>(context, listen: false);

      await authVM.loadToken(); // Garante que o token está carregado
      final token = await authVM.getValidAccessToken();

      if (!mounted) return;

      if (token == null) {
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        await pedidoVM.fetchPedidos();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PedidoViewModel>();
    final authVM = context.watch<AuthViewModel>();

    // Verifica se foi solicitado logout automático (ex: token inválido)
    if (authVM.shouldLogout) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        authVM.resetLogoutFlag();
        Navigator.pushReplacementNamed(context, '/login');
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, '/novo-pedido'),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => vm.fetchPedidos(),
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (vm.error != null) {
            return Center(child: Text('${vm.error}'));
          } else if (vm.pedidos.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum pedido encontrado.',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 15.0,
                  color: Colors.orange,
                ),
              ),
            );
          } else {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: vm.pedidos.length,
              itemBuilder: (context, index) {
                final pedido = vm.pedidos[index];

                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    leading: Icon(
                      pedido.finished ? Icons.check_circle : Icons.timelapse,
                      color: pedido.finished ? Colors.green : Colors.orange,
                      size: 28,
                    ),
                    title: Text(
                      pedido.customerName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(pedido.description),
                    trailing: Text(
                      pedido.finished ? 'Finalizado' : 'Em Andamento',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 15.0,
                        color: pedido.finished ? Colors.green : Colors.orange,
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/detalhes-pedido',
                        arguments: pedido,
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
