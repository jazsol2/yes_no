import 'package:flutter/foundation.dart';
import 'package:myapp/models/order_model.dart';
import 'package:myapp/services/order_service.dart';

class PedidoProvider extends ChangeNotifier {
  final PedidoService _service = PedidoService();
  List<Pedido> _pedidos = [];

  List<Pedido> get pedidos => _pedidos;

  Future<void> fetchPedidos() async {
    try {
      _pedidos = await _service.getPedidos();
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error al obtener pedidos: $e');
      }
    }
  }

  Future<Pedido?> agregarPedido(Pedido pedido) async {
    try {
      final nuevo = await _service.createPedido(pedido);
      _pedidos.add(nuevo);
      notifyListeners();
      return nuevo;
    } catch (e) {
      if (kDebugMode) {
        print('Error al crear pedido: $e');
      }
      return null;
    }
  }

  Future<bool> updatePedido(Pedido pedido) async {
    try {
      final actualizado = await _service.updatePedido(pedido.id!, pedido);
      final index = _pedidos.indexWhere((p) => p.id == pedido.id);
      if (index != -1) {
        _pedidos[index] = actualizado;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Error al actualizar pedido: $e');
      }
      return false;
    }
  }

  Future<bool> desactivarPedido(int id) async {
    try {
      final ok = await _service.desactivarPedido(id);
      if (ok) {
        final index = _pedidos.indexWhere((p) => p.id == id);
        if (index != -1) {
          _pedidos[index] = _pedidos[index].copyWith(isActive: false);
          notifyListeners();
        }
      }
      return ok;
    } catch (e) {
      if (kDebugMode) {
        print('Error al desactivar pedido: $e');
      }
      return false;
    }
  }
}
