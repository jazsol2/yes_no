import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myapp/models/product_model.dart';
import 'package:myapp/services/api_config.dart';


class ProductoService {
  final String baseUrl = ApiConfig.baseUrl;

  Future<List<Producto>> getProductos() async {
    final response = await http.get(Uri.parse('$baseUrl/productos'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Producto.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener productos');
    }
  }

  Future<Producto> createProducto(Producto producto) async {
    final response = await http.post(
      Uri.parse('$baseUrl/productos'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(producto.toJson()),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Producto.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al crear producto');
    }
  }

  Future<bool> updateProducto(int id, Producto producto) async {
    final response = await http.put(
      Uri.parse('$baseUrl/productos/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(producto.toJson()),
    );
    return response.statusCode == 200;
  }

  Future<bool> deactivateProducto(int id) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/productos/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'isActive': false}),
    );
    return response.statusCode == 200;
  }
}
