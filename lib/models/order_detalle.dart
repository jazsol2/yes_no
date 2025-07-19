class PedidoDetalle {
  final int productoId;
  final String productoNombre;
  final int cantidad;
  final bool isActive;

  PedidoDetalle({
    required this.productoId,
    required this.productoNombre,
    required this.cantidad,
    this.isActive = true,
  });

  factory PedidoDetalle.fromJson(Map<String, dynamic> json) {
    return PedidoDetalle(
      productoId: json['productoId'],
      productoNombre: json['producto']['nombre'] ?? '',
      cantidad: json['cantidad'],
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productoId': productoId,
      'cantidad': cantidad,
      'isActive': isActive,
    };
  }
}
