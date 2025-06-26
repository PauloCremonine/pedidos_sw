import 'package:flutter/material.dart';
import 'package:pedidos/theme.dart';
import 'package:pedidos/view/pedidos/pedido_detalhes_screen.dart';
import 'package:pedidos/view/pedidos/pedido_form_screen.dart';
import 'package:provider/provider.dart';
import 'core/di/injector.dart';
import 'view/login/login_screen.dart';
import 'view/pedidos/pedidos_screen.dart';
import 'viewmodel/auth_viewmodel.dart';
import 'viewmodel/pedido_viewmodel.dart';

void main() {
  setupDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getIt<AuthViewModel>()),
        ChangeNotifierProvider(create: (_) => getIt<PedidoViewModel>()),
      ],
      child: MaterialApp(
        title: 'Pedidos App',
        theme: pedidosTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => const LoginScreen(),
          '/login': (context) => const LoginScreen(),
          '/pedidos': (context) => const PedidosScreen(),
          '/novo-pedido': (context) => const PedidoFormScreen(),
          '/detalhes-pedido': (context) => const PedidoDetalhesScreen(),
        },
      ),
    );
  }
}
