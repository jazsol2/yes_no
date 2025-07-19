class ApiConfig {
  static const String baseUrl = 'https://d93a31fa5a23.ngrok-free.app';

  static Map<String, String> headers({String? token}) {
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
}
