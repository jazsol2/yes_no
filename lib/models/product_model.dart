class Producto {
  final int? id;
  final String nombre;
  final double precio;
  final String? descripcion;
  final int stock;
  final bool isActive;

  Producto({
    this.id,
    required this.nombre,
    required this.precio,
    this.descripcion,
    required this.stock,
    this.isActive = true,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'],
      nombre: json['nombre'],
      precio: (json['precio'] as num).toDouble(),
      descripcion: json['descripcion'],
      stock: json['stock'],
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nombre': nombre,
      'precio': precio,
      'descripcion': descripcion,
      'stock': stock,
      'isActive': isActive,
    };
  }
}
