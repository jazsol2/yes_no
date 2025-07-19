import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myapp/models/client_model.dart';
import 'package:myapp/services/api_config.dart';

class ClienteService {
  final String baseUrl = ApiConfig.baseUrl;

  Future<List<Cliente>> getClientes() async {
    final response = await http.get(Uri.parse('$baseUrl/clientes'));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => Cliente.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar clientes');
    }
  }

  Future<Cliente> createCliente(Cliente cliente) async {
    final response = await http.post(
      Uri.parse('$baseUrl/clientes'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(cliente.toJson()),
    );

    if (response.statusCode == 201) {
      return Cliente.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al crear cliente');
    }
  }

  Future<bool> updateCliente(Cliente cliente) async {
    final response = await http.put(
      Uri.parse('$baseUrl/clientes/${cliente.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(cliente.toJson()),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Error al actualizar cliente');
    }
  }

  Future<bool> deactivateCliente(int id) async {
    final response = await http.put(
      Uri.parse('$baseUrl/clientes/$id/deactivate'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Error al desactivar cliente');
    }
  }
}
