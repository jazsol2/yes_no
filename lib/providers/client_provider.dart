import 'package:flutter/material.dart';
import 'package:myapp/models/client_model.dart';
import 'package:myapp/services/client_service.dart';

class ClienteProvider with ChangeNotifier {
  final ClienteService _clienteService = ClienteService();

  List<Cliente> _clientes = [];
  bool _isLoading = false;
  String? _error;

  List<Cliente> get clientes => _clientes;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchClientes() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _clientes = await _clienteService.getClientes();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createCliente(Cliente cliente) async {
    try {
      final nuevo = await _clienteService.createCliente(cliente);
      _clientes.add(nuevo);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      rethrow;
    }
  }

  Future<void> updateCliente(Cliente cliente) async {
    try {
      await _clienteService.updateCliente(cliente);
      final index = _clientes.indexWhere((c) => c.id == cliente.id);
      if (index != -1) {
        _clientes[index] = cliente;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      rethrow;
    }
  }

  Future<void> deactivateCliente(int id) async {
    final index = _clientes.indexWhere((c) => c.id == id);
    if (index == -1) return;

    final original = _clientes[index];

    try {
      _clientes[index] = original.copyWith(isActive: false);
      notifyListeners();

      await _clienteService.deactivateCliente(id);
    } catch (e) {
      _clientes[index] = original;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }
}
