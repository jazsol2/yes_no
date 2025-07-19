import 'package:dio/dio.dart';

T extractData<T>(Response response) {
  final data = response.data;
  if (data is Map && data['data'] is T) {
    return data['data'] as T;
  } else {
    throw Exception('Estructura de respuesta inválida: ${response.data}');
  }
}
