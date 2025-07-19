class Cliente {
  final int? id;
  final String nombre;
  final String apellido;
  final String email;
  final String telefono;
  final bool isActive;

  Cliente({
    this.id,
    required this.nombre,
    required this.apellido,
    required this.email,
    required this.telefono,
    this.isActive = true,
  });

  // Convertir JSON a Cliente (desde backend)
  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'],
      nombre: json['nombre'],
      apellido: json['apellido'],
      email: json['email'],
      telefono: json['telefono'],
      isActive: json['isActive'] ?? true,
    );
  }

  // Convertir Cliente a JSON (para enviar al backend)
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nombre': nombre,
      'apellido': apellido,
      'email': email,
      'telefono': telefono,
      'isActive': isActive,
    };
  }
}
