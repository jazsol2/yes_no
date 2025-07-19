import 'package:go_router/go_router.dart';


// Clientes
import 'package:myapp/screens/clients/client_form_screen.dart';
import 'package:myapp/screens/clients/client_list_screen.dart';

// Screens
import 'package:myapp/screens/login_screen.dart';
import 'package:myapp/screens/home_screen.dart';

// Pedidos
import 'package:myapp/screens/orders/order_form_screen.dart';
import 'package:myapp/screens/orders/order_list_screen.dart';

// Productos
import 'package:myapp/screens/products/product_form_screen.dart';
import 'package:myapp/screens/products/product_list_screen.dart';

// Usuarios
import 'package:myapp/screens/users/user_form_screen.dart';
import 'package:myapp/screens/users/user_list_screen.dart';


final GoRouter router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => HomeScreen(),
    ),

    // CLIENTES
    GoRoute(
      path: '/clientes',
      builder: (context, state) => ClientesScreen(),
    ),
    GoRoute(
      path: '/clientes/form',
      builder: (context, state) => ClienteFormScreen(),
    ),
    GoRoute(
      path: '/clientes/form/:id',
      builder: (context, state) {
        final id = int.tryParse(state.pathParameters['id'] ?? '');
        return ClienteFormScreen(clienteId: id);
      },
    ),

    // USUARIOS
    GoRoute(
      path: '/usuarios',
      builder: (context, state) => UserScreen(),
    ),
    GoRoute(
      path: '/usuarios/form',
      builder: (context, state) => UserFormScreen(),
    ),
    GoRoute(
      path: '/usuarios/form/:id',
      builder: (context, state) {
        final id = int.tryParse(state.pathParameters['id'] ?? '');
        return UserFormScreen(usuarioId: id);
      },
    ),

    // PRODUCTOS
    GoRoute(
      path: '/productos',
      builder: (context, state) => ProductosScreen(),
    ),
    GoRoute(
      path: '/productos/form',
      builder: (context, state) => ProductoForm(),
    ),
    GoRoute(
      path: '/productos/form/:id',
      builder: (context, state) {
        final id = int.tryParse(state.pathParameters['id'] ?? '');
        return ProductoForm(productoId: id);
      },
    ),

    // PEDIDOS
    GoRoute(
      path: '/pedidos',
      builder: (context, state) => PedidosScreen(),
    ),
    GoRoute(
      path: '/pedidos/form',
      builder: (context, state) => PedidoFormScreen(clientes: [], productos: [],),
    ),
    GoRoute(
      path: '/pedidos/form/:id',
      builder: (context, state) {
        final id = int.tryParse(state.pathParameters['id'] ?? '');
        return PedidoFormScreen(pedidoId: id, clientes: [], productos: [],);
      },
    ),
  ],
);
