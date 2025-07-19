import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:myapp/models/product_model.dart';
import 'api_config.dart';

class ProductoService {
  final Dio _dio = Dio();

  Future<List<Producto>> getProductos() async {
    final response = await _dio.get('${ApiConfig.baseUrl}/productos');
    return (response.data as List)
        .map((json) => Producto.fromJson(json))
        .toList();
  }

  Future<Producto> getProductoById(int id) async {
    final response = await _dio.get('${ApiConfig.baseUrl}/productos/$id');
    return Producto.fromJson(response.data);
  }

  Future<Producto> createProducto(Producto producto) async {
    final response = await _dio.post('${ApiConfig.baseUrl}/productos', data: producto.toJson());
    return Producto.fromJson(response.data);
  }

  Future<bool> updateProducto(Producto producto) async {
    try {
      final response = await _dio.put(
        '${ApiConfig.baseUrl}/productos/${producto.id}',
        data: producto.toJson(),
      );
      return response.statusCode == 200;
    } catch (e) {
      if (kDebugMode) {
        print('Error actualizando producto: $e');
      }
      return false;
    }
  }

  Future<void> desactivarProducto(int id) async {
    await _dio.delete('${ApiConfig.baseUrl}/productos/$id');
  }
}
