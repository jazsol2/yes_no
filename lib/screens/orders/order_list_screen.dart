import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/providers/order_provider.dart';
import 'package:provider/provider.dart';

class PedidoScreen extends StatefulWidget {
  const PedidoScreen({super.key});

  @override
  State<PedidoScreen> createState() => _PedidoScreenState();
}

class _PedidoScreenState extends State<PedidoScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PedidoProvider>().fetchPedidos();
  }

  @override
  Widget build(BuildContext context) {
    final pedidoProvider = context.watch<PedidoProvider>();
    final pedidos = pedidoProvider.pedidos;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<PedidoProvider>().fetchPedidos(),
          ),
        ],
      ),
      body: pedidos.isEmpty
          ? const Center(child: Text('No hay pedidos registrados.'))
          : ListView.builder(
              itemCount: pedidos.length,
              itemBuilder: (context, index) {
                final pedido = pedidos[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text('Pedido #${pedido.id ?? '-'} - Cliente: ${pedido.clienteId}'),
                    subtitle: Text('Total: \$${pedido.total.toStringAsFixed(2)} | Estado: ${pedido.estado}'),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) async {
                        if (value == 'editar') {
                          context.push('/pedidos/editar', extra: pedido);
                        } else if (value == 'desactivar') {
                          final ok = await pedidoProvider.desactivarPedido(pedido.id!);
                          if (!mounted) return;
                          if (ok) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Pedido desactivado')),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Error al desactivar pedido')),
                            );
                          }
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'editar',
                          child: Text('Editar'),
                        ),
                        const PopupMenuItem(
                          value: 'desactivar',
                          child: Text('Desactivar'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/pedidos/nuevo'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
