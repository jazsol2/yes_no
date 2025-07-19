import 'package:dio/dio.dart';
import 'package:myapp/models/order_model.dart';
import 'package:myapp/services/api_config.dart';

class PedidoService {
  final Dio _dio = Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));

  Future<List<Pedido>> getPedidos() async {
    final response = await _dio.get('/pedidos');
    return (response.data as List).map((e) => Pedido.fromJson(e)).toList();
  }

  Future<Pedido> createPedido(Pedido pedido) async {
    final response = await _dio.post('/pedidos', data: pedido.toJson());
    return Pedido.fromJson(response.data);
  }

  Future<Pedido> updatePedido(int id, Pedido pedido) async {
    final response = await _dio.put('/pedidos/$id', data: pedido.toJson());
    return Pedido.fromJson(response.data);
  }

  Future<bool> deletePedido(int id) async {
    final response = await _dio.delete('/pedidos/$id');
    return response.statusCode == 200;
  }

  Future<Pedido?> getPedidoById(int id) async {
    final response = await _dio.get('/pedidos/$id');
    if (response.statusCode == 200) {
      return Pedido.fromJson(response.data);
    }
    return null;
  }

  Future<bool> desactivarPedido(int id) async {
    final response = await _dio.patch('/pedidos/$id/desactivar');
    return response.statusCode == 200;
  }
}
