import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_HomeCard> cards = [
      _HomeCard(label: 'Usuarios', route: '/usuarios'),
      _HomeCard(label: 'Clientes', route: '/clientes'),
      _HomeCard(label: 'Productos', route: '/productos'),
      _HomeCard(label: 'Pedidos', route: '/pedidos'),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Inicio')),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: cards.map((card) => card).toList(),
      ),
    );
  }
}

class _HomeCard extends StatelessWidget {
  final String label;
  final String route;

  const _HomeCard({required this.label, required this.route});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(route),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        color: Colors.blueAccent,
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
