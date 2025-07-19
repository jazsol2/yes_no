import 'package:myapp/models/order_detalle.dart';

class Pedido {
  final int? id;
  final int clienteId;
  final double total;
  final String estado;
  final bool isActive;
  final List<PedidoDetalle> detalles;

  Pedido({
    this.id,
    required this.clienteId,
    required this.total,
    required this.estado,
    this.isActive = true,
    this.detalles = const [],
  });

  factory Pedido.fromJson(Map<String, dynamic> json) {
    return Pedido(
      id: json['id'],
      clienteId: json['clienteId'],
      total: (json['total'] as num).toDouble(),
      estado: json['estado'],
      isActive: json['isActive'] ?? true,
      detalles: (json['detalles'] as List<dynamic>?)
              ?.map((d) => PedidoDetalle.fromJson(d))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clienteId': clienteId,
      'total': total,
      'estado': estado,
      'isActive': isActive,
      'detalles': detalles.map((d) => d.toJson()).toList(),
    };
  }

  Pedido copyWith({
    int? id,
    int? clienteId,
    double? total,
    String? estado,
    bool? isActive,
    List<PedidoDetalle>? detalles,
  }) {
    return Pedido(
      id: id ?? this.id,
      clienteId: clienteId ?? this.clienteId,
      total: total ?? this.total,
      estado: estado ?? this.estado,
      isActive: isActive ?? this.isActive,
      detalles: detalles ?? this.detalles,
    );
  }
}
