import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/client_provider.dart';
import 'package:myapp/providers/order_provider.dart';
import 'package:myapp/providers/product_provider.dart';
import 'package:myapp/providers/user_provider.dart';
import 'package:myapp/routes/app_router.dart';  // donde tengas tu appRouter

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            final productoProvider = ProductoProvider();
            productoProvider.loadProductos();
            return productoProvider;
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            final clienteProvider = ClienteProvider();
            clienteProvider.loadClientes();
            return clienteProvider;
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            final pedidoProvider = PedidoProvider();
            pedidoProvider.fetchPedidos();
            return pedidoProvider;
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            final usuarioProvider = UserProvider();
            usuarioProvider.fetchUsers();
            return usuarioProvider;
          },
        ),
      ],
      child: MaterialApp.router(
        title: 'Restaurante App',
        routerConfig: appRouter,  // aquí pones tu router definido
      ),
    );
  }
}
