import 'package:flutter/material.dart';
import 'package:myapp/models/product_model.dart';
import 'package:myapp/services/product_service.dart';

class ProductoProvider with ChangeNotifier {
  final ProductoService _productoService = ProductoService();

  List<Producto> _productos = [];
  bool _isLoading = false;
  String? _error;

  List<Producto> get productos => _productos;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchProductos() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _productos = await _productoService.getProductos();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createProducto(Producto producto) async {
    try {
      final created = await _productoService.createProducto(producto);
      _productos.add(created);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      rethrow;
    }
  }

  Future<void> updateProducto(Producto producto) async {
    try {
      await _productoService.updateProducto(producto.id, producto);
      final index = _productos.indexWhere((p) => p.id == producto.id);
      if (index != -1) {
        _productos[index] = producto;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      rethrow;
    }
  }

  Future<void> deactivateProducto(int id) async {
    final index = _productos.indexWhere((p) => p.id == id);
    if (index == -1) return;

    final originalProducto = _productos[index];
    try {
      _productos[index] = originalProducto.copyWith(isActive: false);
      notifyListeners();

      await _productoService.deactivateProducto(id);
    } catch (e) {
      _productos[index] = originalProducto;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }
}
