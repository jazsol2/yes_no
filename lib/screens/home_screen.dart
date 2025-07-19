import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/screens/users/user_list_screen.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menú Principal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            ElevatedButton.icon(
              icon: Icon(Icons.person),
              label: Text('Usuarios'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => UserScreen()),
                );
              },
            ),
            ElevatedButton(
              onPressed: () => context.go('/clientes'),
              child: const Text('Clientes'),
            ),
            ElevatedButton(
              onPressed: () => context.go('/usuarios'),
              child: const Text('Usuarios'),
            ),
            ElevatedButton(
              onPressed: () => context.go('/productos'),
              child: const Text('Productos'),
            ),
            ElevatedButton(
              onPressed: () => context.go('/pedidos'),
              child: const Text('Pedidos'),
            ),
          ],
        ),
      ),
    );
  }
}
