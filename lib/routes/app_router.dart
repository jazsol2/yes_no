import 'package:go_router/go_router.dart';
import 'package:myapp/models/order_model.dart';
import 'package:myapp/models/product_model.dart';
import 'package:myapp/models/client_model.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/screens/clients/client_form_screen.dart';
import 'package:myapp/screens/clients/client_list_screen.dart';

import 'package:myapp/screens/home_screen.dart';
import 'package:myapp/screens/orders/order_form_screen.dart';
import 'package:myapp/screens/orders/order_list_screen.dart';
import 'package:myapp/screens/products/product_form_screen.dart';
import 'package:myapp/screens/products/product_list_screen.dart';
import 'package:myapp/screens/users/user_list_screen.dart';
import 'package:myapp/screens/users/user_form_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),

    // Usuarios
    GoRoute(
      path: '/usuarios',
      builder: (context, state) => const UserScreen(),
      routes: [
        GoRoute(
          path: 'form',
          builder: (context, state) {
            final user = state.extra as User?;
            return UserFormScreen(user: user);
          },
        ),
      ],
    ),

    // Clientes
    GoRoute(
      path: '/clientes',
      builder: (context, state) => const ClienteListScreen(),
      routes: [
        GoRoute(
          path: 'form',
          builder: (context, state) {
            final cliente = state.extra as Cliente?;
            return ClienteFormScreen(cliente: cliente);
          },
        ),
      ],
    ),

    // Productos
    GoRoute(
      path: '/productos',
      builder: (context, state) => const ProductoListScreen(),
      routes: [
        GoRoute(
          path: 'form',
          builder: (context, state) {
            final producto = state.extra as Producto?;
            return ProductoFormScreen(producto: producto);
          },
        ),
      ],
    ),

    // Pedidos
    GoRoute(
      path: '/pedidos',
      builder: (context, state) => const PedidoScreen(),
      routes: [
        GoRoute(
          path: 'form',
          builder: (context, state) {
            final pedido = state.extra as Pedido?;
            return PedidoFormScreen(pedido: pedido);
          },
        ),
      ],
    ),
  ],
);
