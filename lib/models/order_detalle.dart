class PedidoDetalle {
  final int? id;
  final int pedidoId;
  late final int productoId;
  late final int cantidad;
  late final double precioUnitario;

  PedidoDetalle({
    this.id,
    required this.pedidoId,
    required this.productoId,
    required this.cantidad,
    required this.precioUnitario,
  });

  factory PedidoDetalle.fromJson(Map<String, dynamic> json) {
    return PedidoDetalle(
      id: json['id'],
      pedidoId: json['pedidoId'],
      productoId: json['productoId'],
      cantidad: json['cantidad'],
      precioUnitario: (json['precioUnitario'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pedidoId': pedidoId,
      'productoId': productoId,
      'cantidad': cantidad,
      'precioUnitario': precioUnitario,
    };
  }
}
