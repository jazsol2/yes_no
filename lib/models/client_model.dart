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

  // 👇 Aquí agregamos copyWith
  Cliente copyWith({
    int? id,
    String? nombre,
    String? apellido,
    String? email,
    String? telefono,
    bool? isActive,
  }) {
    return Cliente(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      apellido: apellido ?? this.apellido,
      email: email ?? this.email,
      telefono: telefono ?? this.telefono,
      isActive: isActive ?? this.isActive,
    );
  }

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
