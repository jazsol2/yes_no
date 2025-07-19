import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:myapp/models/client_model.dart';
import 'api_config.dart';

class ClienteService {
  final Dio _dio = Dio();

  // Obtener lista de clientes
  Future<List<Cliente>> getClientes() async {
    final response = await _dio.get('${ApiConfig.baseUrl}/clientes');
    return (response.data as List).map((json) => Cliente.fromJson(json)).toList();
  }

  // Obtener cliente por ID
  Future<Cliente> getClienteById(int id) async {
    final response = await _dio.get('${ApiConfig.baseUrl}/clientes/$id');
    return Cliente.fromJson(response.data);
  }

  // Crear cliente
  Future<Cliente> createCliente(Cliente cliente) async {
    final response = await _dio.post('${ApiConfig.baseUrl}/clientes', data: cliente.toJson());
    return Cliente.fromJson(response.data);
  }

  // Actualizar cliente
  Future<bool> updateCliente(Cliente cliente) async {
    try {
      final response = await _dio.put(
        '${ApiConfig.baseUrl}/clientes/${cliente.id}',
        data: cliente.toJson(),
      );
      return response.statusCode == 200;
    } catch (e) {
      if (kDebugMode) {
        print('Error actualizando cliente: $e');
      }
      return false;
    }
  }

  // Desactivar (eliminar lógico) cliente
  Future<void> desactivarCliente(int id) async {
    await _dio.delete('${ApiConfig.baseUrl}/clientes/$id');
  }
}
