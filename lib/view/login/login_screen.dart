import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/auth_viewmodel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController(
    text: 'paulocremonine@gmail.com',
  );
  final _passwordController = TextEditingController(text: 'exWNldgttmcP');

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 50),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Usuário'),
            ),
            SizedBox(height: 50),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            authVM.isLoading
                ? const CircularProgressIndicator()
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        await authVM.login(
                          username: _usernameController.text.trim(),
                          password: _passwordController.text.trim(),
                        );

                        if (authVM.accessToken != null) {
                          // Navegar para tela principal, ex: PedidosScreen
                          Navigator.of(
                            context,
                          ).pushReplacementNamed('/pedidos');
                        } else if (authVM.error != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(authVM.error!)),
                          );
                        }
                      },
                      child: const Text('Login'),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
