import 'package:flutter/material.dart';
import 'package:myapp/providers/client_provider.dart';
import 'package:myapp/screens/clients/client_form_screen.dart';
import 'package:provider/provider.dart';

class ClienteListScreen extends StatefulWidget {
  const ClienteListScreen({super.key});

  @override
  State<ClienteListScreen> createState() => _ClienteListScreenState();
}

class _ClienteListScreenState extends State<ClienteListScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<ClienteProvider>(context, listen: false).loadClientes();
  }

  @override
  Widget build(BuildContext context) {
    final clienteProvider = Provider.of<ClienteProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Clientes')),
      body: ListView.builder(
        itemCount: clienteProvider.clientes.length,
        itemBuilder: (context, index) {
          final cliente = clienteProvider.clientes[index];
          return ListTile(
            title: Text('${cliente.nombre} ${cliente.apellido}'),
            subtitle: Text(cliente.email),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ClienteFormScreen(cliente: cliente),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ClienteFormScreen(),
            ),
          );
        },
      ),
    );
  }
}
