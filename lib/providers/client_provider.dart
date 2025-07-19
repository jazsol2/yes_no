import 'package:flutter/material.dart';
import 'package:myapp/models/client_model.dart';
import 'package:myapp/services/client_service.dart';

class ClienteProvider extends ChangeNotifier {
  final ClienteService _clienteService = ClienteService();
  List<Cliente> _clientes = [];

  List<Cliente> get clientes => _clientes;

  // Carga la lista de clientes desde el backend
  Future<void> loadClientes() async {
    _clientes = await _clienteService.getClientes();
    notifyListeners();
  }

  // Agrega un nuevo cliente
  Future<void> addCliente(Cliente cliente) async {
    await _clienteService.createCliente(cliente);
    await loadClientes();  // refresca la lista después de agregar
  }

  // Actualiza un cliente existente
  Future<void> updateCliente(Cliente cliente) async {
    await _clienteService.updateCliente(cliente);
    await loadClientes();  // refresca la lista después de actualizar
  }

  // Desactiva (elimina lógico) un cliente por id
  Future<void> deleteCliente(int id) async {
    await _clienteService.desactivarCliente(id);
    await loadClientes();  // refresca la lista después de eliminar
  }
}

