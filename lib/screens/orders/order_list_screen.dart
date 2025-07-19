import 'package:flutter/material.dart';
import 'package:myapp/providers/order_provider.dart';
import 'package:provider/provider.dart';

class PedidosScreen extends StatefulWidget {
  const PedidosScreen({super.key});

  @override
  State<PedidosScreen> createState() => _PedidosScreenState();
}

class _PedidosScreenState extends State<PedidosScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar pedidos al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PedidoProvider>(context, listen: false).fetchPedidos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final pedidoProvider = Provider.of<PedidoProvider>(context);
    final pedidos = pedidoProvider.pedidos;
    final isLoading = pedidoProvider.isLoading;
    final error = pedidoProvider.error;

    return Scaffold(
      appBar: AppBar(
        title: Text('Pedidos'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => pedidoProvider.fetchPedidos(),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text('Error: $error'))
              : pedidos.isEmpty
                  ? Center(child: Text('No hay pedidos'))
                  : ListView.builder(
                      itemCount: pedidos.length,
                      itemBuilder: (context, index) {
                        final pedido = pedidos[index];
                        return ListTile(
                          title: Text('Pedido #${pedido.id ?? "N/A"} - Cliente: ${pedido.clienteId}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Estado: ${pedido.estado}'),
                              Text('Total: \$${pedido.total.toStringAsFixed(2)}'),
                              Text('Activo: ${pedido.isActive ? "Sí" : "No"}'),
                              SizedBox(height: 4),
                              Text('Detalles:'),
                              ...pedido.detalles.map((d) => Text('- ${d.productoNombre}: ${d.cantidad}')),
                            ],
                          ),
                          isThreeLine: true,
                          trailing: Switch(
                            value: pedido.isActive,
                            onChanged: (value) {
                              pedidoProvider.deactivatePedido(pedido.id!);
                            },
                          ),
                          onTap: () {
                            // Aquí puedes navegar a un formulario de edición de pedido
                          },
                        );
                      },
                    ),
    );
  }
}
