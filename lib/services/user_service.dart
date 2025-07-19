import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myapp/models/user_model.dart';
import 'package:myapp/services/api_config.dart';


class UserService {
  final String baseUrl = ApiConfig.baseUrl;

  Future<List<User>> getUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/usuarios'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener usuarios');
    }
  }

  Future<bool> createUser(User user, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/usuarios'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "email": user.email,
        "name": user.name,
        "password": password,  // Password necesario para crear
        "isActive": user.isActive,
      }),
    );
    return response.statusCode == 201 || response.statusCode == 200;
  }

  Future<bool> updateUser(User user) async {
    final response = await http.put(
      Uri.parse('$baseUrl/usuarios/${user.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "email": user.email,
        "name": user.name,
        "isActive": user.isActive,
      }),
    );
    return response.statusCode == 200;
  }

  Future<bool> updateIsActive(int id, bool isActive) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/usuarios/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'isActive': isActive}),
    );
    return response.statusCode == 200;
  }
}
