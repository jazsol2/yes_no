// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:myapp/models/order_model.dart';
import 'package:myapp/models/order_detalle.dart';
import 'package:myapp/models/client_model.dart';
import 'package:myapp/models/product_model.dart';
import 'package:myapp/services/order_service.dart';

class PedidoFormScreen extends StatefulWidget {
  final Pedido? pedido;
  final List<Cliente> clientes;
  final List<Producto> productos;

  const PedidoFormScreen({
    super.key,
    this.pedido,
    required this.clientes,
    required this.productos, int? pedidoId,
  });

  @override
  _PedidoFormScreenState createState() => _PedidoFormScreenState();
}

class _PedidoFormScreenState extends State<PedidoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late int selectedClienteId;
  List<PedidoDetalle> detalles = [];
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    selectedClienteId = widget.pedido?.clienteId ?? (widget.clientes.isNotEmpty ? widget.clientes.first.id! : 0);
    detalles = widget.pedido?.detalles.toList() ?? [];
  }

  double get total => detalles.fold(0, (sum, d) {
    final producto = widget.productos.firstWhere((p) => p.id == d.productoId, orElse: () => Producto(id: 0, nombre: '', precio: 0, descripcion: '', stock: 0, isActive: true));
    return sum + (producto.precio * d.cantidad);
  });

  void addDetalle(Producto producto) {
    final index = detalles.indexWhere((d) => d.productoId == producto.id);
    if (index != -1) {
      setState(() {
        detalles[index] = PedidoDetalle(
          productoId: producto.id,
          productoNombre: producto.nombre,
          cantidad: detalles[index].cantidad + 1,
        );
      });
    } else {
      setState(() {
        detalles.add(PedidoDetalle(
          productoId: producto.id,
          productoNombre: producto.nombre,
          cantidad: 1,
        ));
      });
    }
  }

  void removeDetalle(PedidoDetalle detalle) {
    setState(() {
      detalles.removeWhere((d) => d.productoId == detalle.productoId);
    });
  }

  Future<void> savePedido() async {
    if (!_formKey.currentState!.validate()) return;
    if (detalles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Agrega al menos un producto')));
      return;
    }

    setState(() => isSaving = true);

    final pedido = Pedido(
      id: widget.pedido?.id,
      clienteId: selectedClienteId,
      total: total,
      estado: widget.pedido?.estado ?? 'pendiente',
      isActive: widget.pedido?.isActive ?? true,
      detalles: detalles,
    );

    try {
      final pedidoService = PedidoService();
      bool ok;
      if (widget.pedido == null) {
        ok = await pedidoService.createPedidoWithDetails(pedido);
      } else {
        ok = await pedidoService.updatePedido(pedido);
      }

      setState(() => isSaving = false);

      if (ok) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al guardar pedido')));
      }
    } catch (e) {
      setState(() => isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.pedido == null ? 'Nuevo Pedido' : 'Editar Pedido')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<int>(
                decoration: InputDecoration(labelText: 'Cliente'),
                value: selectedClienteId,
                items: widget.clientes.map((c) => DropdownMenuItem(
                  value: c.id,
                  child: Text('${c.nombre} ${c.apellido}'),
                )).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      selectedClienteId = val;
                    });
                  }
                },
                validator: (v) => v == null || v == 0 ? 'Seleccione un cliente' : null,
              ),
              SizedBox(height: 20),
              Text('Productos disponibles:'),
              ...widget.productos.where((p) => p.isActive).map((producto) => ListTile(
                title: Text(producto.nombre),
                subtitle: Text('Precio: \$${producto.precio.toStringAsFixed(2)} - Stock: ${producto.stock}'),
                trailing: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    addDetalle(producto);
                  },
                ),
              )),
              Divider(),
              Text('Detalle del pedido:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...detalles.map((detalle) => ListTile(
                title: Text(detalle.productoNombre),
                subtitle: Text('Cantidad: ${detalle.cantidad}'),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => removeDetalle(detalle),
                ),
              )),
              Divider(),
              Text('Total: \$${total.toStringAsFixed(2)}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              isSaving
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: savePedido,
                      child: Text('Guardar Pedido'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
