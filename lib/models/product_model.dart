class Producto {
  final int id;
  final String nombre;
  final double precio;
  final String? descripcion;
  final int stock;
  bool isActive;

  Producto({
    required this.id,
    required this.nombre,
    required this.precio,
    this.descripcion,
    required this.stock,
    required this.isActive,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'],
      nombre: json['nombre'],
      precio: (json['precio'] as num).toDouble(),
      descripcion: json['descripcion'],
      stock: json['stock'],
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'precio': precio,
      'descripcion': descripcion,
      'stock': stock,
      'isActive': isActive,
    };
  }

  Producto copyWith({
    int? id,
    String? nombre,
    double? precio,
    String? descripcion,
    int? stock,
    bool? isActive,
  }) {
    return Producto(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      precio: precio ?? this.precio,
      descripcion: descripcion ?? this.descripcion,
      stock: stock ?? this.stock,
      isActive: isActive ?? this.isActive,
    );
  }
}
