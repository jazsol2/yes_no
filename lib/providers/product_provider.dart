import 'package:flutter/material.dart';
import 'package:myapp/models/product_model.dart';
import 'package:myapp/services/product_service.dart';

class ProductoProvider extends ChangeNotifier {
  final ProductoService _productoService = ProductoService();
  List<Producto> _productos = [];

  List<Producto> get productos => _productos;

  Future<void> loadProductos() async {
    _productos = await _productoService.getProductos();
    notifyListeners();
  }

  Future<void> addProducto(Producto producto) async {
    await _productoService.createProducto(producto);
    await loadProductos();
  }

  Future<void> updateProducto(Producto producto) async {
    await _productoService.updateProducto(producto);
    await loadProductos();
  }

  Future<void> deleteProducto(int id) async {
    await _productoService.desactivarProducto(id);
    await loadProductos();
  }
}
