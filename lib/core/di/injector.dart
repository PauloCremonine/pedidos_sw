import 'package:get_it/get_it.dart';
import 'package:pedidos/core/auth_http_client.dart';
import 'package:pedidos/data/repositories/auth_repository.dart';
import 'package:pedidos/data/repositories/pedido_repository.dart';
import 'package:pedidos/viewmodel/auth_viewmodel.dart';
import 'package:pedidos/viewmodel/pedido_viewmodel.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepository());

  getIt.registerLazySingleton<AuthViewModel>(
    () => AuthViewModel(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<AuthHttpClient>(
    () => AuthHttpClient(authViewModel: getIt<AuthViewModel>()),
  );

  getIt.registerLazySingleton<PedidoRepository>(
    () => PedidoRepository(client: getIt<AuthHttpClient>()),
  );

  getIt.registerFactory<PedidoViewModel>(
    () => PedidoViewModel(getIt<PedidoRepository>()),
  );
}
