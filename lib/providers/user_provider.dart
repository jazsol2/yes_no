import 'package:flutter/material.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/services/user_service.dart';

class UserProvider with ChangeNotifier {
  final UserService _userService = UserService();

  List<User> _users = [];
  bool _isLoading = false;
  String? _error;

  List<User> get users => _users;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Obtener todos los usuarios
  Future<void> fetchUsers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _users = await _userService.getUsers();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Crear usuario
  Future<void> createUser(User user, String password) async {
    try {
      final success = await _userService.createUser(user, password);
      if (success) {
        _users.add(user);
        notifyListeners();
      } else {
        throw Exception('No se pudo crear el usuario');
      }
    } catch (e) {
      _error = e.toString();
      rethrow;
    }
  }

  // Actualizar usuario
  Future<void> updateUser(User user) async {
    try {
      final success = await _userService.updateUser(user);
      if (success) {
        final index = _users.indexWhere((u) => u.id == user.id);
        if (index != -1) {
          _users[index] = user;
          notifyListeners();
        }
      } else {
        throw Exception('No se pudo actualizar el usuario');
      }
    } catch (e) {
      _error = e.toString();
      rethrow;
    }
  }

  // Cambiar estado activo/inactivo del usuario
  Future<void> updateIsActive(int id, bool isActive) async {
    try {
      final success = await _userService.updateIsActive(id, isActive);
      if (success) {
        final index = _users.indexWhere((u) => u.id == id);
        if (index != -1) {
          _users[index] = _users[index].copyWith(isActive: isActive);
          notifyListeners();
        }
      } else {
        throw Exception('No se pudo actualizar el estado del usuario');
      }
    } catch (e) {
      _error = e.toString();
      rethrow;
    }
  }
}
