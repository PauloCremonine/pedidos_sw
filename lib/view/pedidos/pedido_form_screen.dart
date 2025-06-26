import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/pedido_viewmodel.dart';

class PedidoFormScreen extends StatefulWidget {
  const PedidoFormScreen({super.key});

  @override
  State<PedidoFormScreen> createState() => _PedidoFormScreenState();
}

class _PedidoFormScreenState extends State<PedidoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();

  bool _isSubmitting = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final vm = Provider.of<PedidoViewModel>(context, listen: false);
      await vm.createPedido(
        customerName: _nameController.text.trim(),
        description: _descController.text.trim(),
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pedido criado com sucesso!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo Pedido')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 50),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome do cliente'),
                validator: (value) =>
                    value!.isEmpty ? 'Informe o nome do cliente' : null,
              ),
              SizedBox(height: 50),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                validator: (value) =>
                    value!.isEmpty ? 'Informe a descrição' : null,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  child: _isSubmitting
                      ? const CircularProgressIndicator()
                      : const Text('Salvar Pedido'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
