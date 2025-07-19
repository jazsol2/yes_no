import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myapp/models/order_model.dart';
import 'package:myapp/services/api_config.dart';

class PedidoService {
  final String baseUrl = ApiConfig.baseUrl;

  // Crear pedido con detalles
  Future<bool> createPedidoWithDetails(Pedido pedido) async {
    final response = await http.post(
      Uri.parse('$baseUrl/pedidos'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "clienteId": pedido.clienteId,
        "total": pedido.total,
        "estado": pedido.estado,
        "isActive": pedido.isActive,
        "detalles": pedido.detalles.map((d) => {
          "productoId": d.productoId,
          "cantidad": d.cantidad,
          "isActive": true,
        }).toList(),
      }),
    );
    return response.statusCode == 201 || response.statusCode == 200;
  }

  // Obtener lista de pedidos
  Future<List<Pedido>> getPedidos() async {
    final response = await http.get(Uri.parse('$baseUrl/pedidos'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Pedido.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener pedidos');
    }
  }

  // Actualizar pedido
  Future<bool> updatePedido(Pedido pedido) async {
    final response = await http.put(
      Uri.parse('$baseUrl/pedidos/${pedido.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "clienteId": pedido.clienteId,
        "total": pedido.total,
        "estado": pedido.estado,
        "isActive": pedido.isActive,
        "detalles": pedido.detalles.map((d) => {
          "productoId": d.productoId,
          "cantidad": d.cantidad,
          "isActive": d.isActive,
        }).toList(),
      }),
    );
    return response.statusCode == 200;
  }

  // Desactivar pedido (set isActive = false)
  Future<bool> deactivatePedido(int id) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/pedidos/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"isActive": false}),
    );
    return response.statusCode == 200;
  }
}
