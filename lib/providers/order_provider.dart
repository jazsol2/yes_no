import 'package:flutter/material.dart';
import 'package:myapp/models/order_model.dart';
import 'package:myapp/services/order_service.dart';


class PedidoProvider with ChangeNotifier {
  final PedidoService _pedidoService = PedidoService();

  List<Pedido> _pedidos = [];
  bool _isLoading = false;
  String? _error;

  List<Pedido> get pedidos => _pedidos;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchPedidos() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _pedidos = await _pedidoService.getPedidos();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createPedido(Pedido pedido) async {
    try {
      final ok = await _pedidoService.createPedidoWithDetails(pedido);
      if (ok) {
        _pedidos.add(pedido);
        notifyListeners();
      } else {
        throw Exception('Error creando pedido');
      }
    } catch (e) {
      _error = e.toString();
      rethrow;
    }
  }

  Future<void> updatePedido(Pedido pedido) async {
    try {
      final ok = await _pedidoService.updatePedido(pedido);
      if (ok) {
        final index = _pedidos.indexWhere((p) => p.id == pedido.id);
        if (index != -1) {
          _pedidos[index] = pedido;
          notifyListeners();
        }
      } else {
        throw Exception('Error actualizando pedido');
      }
    } catch (e) {
      _error = e.toString();
      rethrow;
    }
  }

  Future<void> deactivatePedido(int id) async {
    final index = _pedidos.indexWhere((p) => p.id == id);
    if (index == -1) return;

    final originalPedido = _pedidos[index];
    try {
      _pedidos[index] = originalPedido.copyWith(isActive: false);
      notifyListeners();

      final ok = await _pedidoService.deactivatePedido(id);
      if (!ok) throw Exception('Error desactivando pedido');
    } catch (e) {
      _pedidos[index] = originalPedido;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }
}
