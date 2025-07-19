import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/providers/client_provider.dart';

class ClientesScreen extends StatefulWidget {
  const ClientesScreen({super.key});

  @override
  State<ClientesScreen> createState() => _ClientesScreenState();
}

class _ClientesScreenState extends State<ClientesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ClienteProvider>(context, listen: false).fetchClientes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final clienteProvider = Provider.of<ClienteProvider>(context);
    final clientes = clienteProvider.clientes;
    final isLoading = clienteProvider.isLoading;
    final error = clienteProvider.error;

    return Scaffold(
      appBar: AppBar(title: const Text('Clientes')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text('Error: $error'))
              : ListView.builder(
                  itemCount: clientes.length,
                  itemBuilder: (context, index) {
                    final cliente = clientes[index];
                    return ListTile(
                      title: Text('${cliente.nombre} ${cliente.apellido}'),
                      subtitle: Text('Email: ${cliente.email}'),
                      trailing: Switch(
                        value: cliente.isActive,
                        onChanged: (value) async {
                          try {
                            await clienteProvider.deactivateCliente(cliente.id!);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: $e')),
                            );
                          }
                        },
                      ),
                      onTap: () async {
                        final updated = await context.push<bool>(
                          '/clientes/form',
                          extra: cliente,
                        );
                        if (updated == true) {
                          clienteProvider.fetchClientes();
                        }
                      },
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final created = await context.push<bool>('/clientes/form');
          if (created == true) {
            clienteProvider.fetchClientes();
          }
        },
      ),
    );
  }
}
