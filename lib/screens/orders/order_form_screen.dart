import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/models/order_model.dart';
import 'package:myapp/models/order_detalle.dart';
import 'package:myapp/providers/order_provider.dart';
import 'package:provider/provider.dart';

class PedidoFormScreen extends StatefulWidget {
  final Pedido? pedido;
  const PedidoFormScreen({super.key, this.pedido});

  @override
  State<PedidoFormScreen> createState() => _PedidoFormScreenState();
}

class _PedidoFormScreenState extends State<PedidoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final clienteIdCtrl = TextEditingController();
  final estadoCtrl = TextEditingController();
  bool isActive = true;

  final List<PedidoDetalle> detalles = [];

  @override
  void initState() {
    super.initState();
    if (widget.pedido != null) {
      clienteIdCtrl.text = widget.pedido!.clienteId.toString();
      estadoCtrl.text = widget.pedido!.estado;
      isActive = widget.pedido!.isActive;
      detalles.addAll(widget.pedido!.detalles);
    }
  }

  void agregarDetalle() {
    setState(() {
      detalles.add(PedidoDetalle(
        pedidoId: widget.pedido?.id ?? 0,
        productoId: 0,
        cantidad: 1,
        precioUnitario: 0.0,
      ));
    });
  }

  void eliminarDetalle(int index) {
    setState(() {
      detalles.removeAt(index);
    });
  }

  Future<void> guardar() async {
    if (_formKey.currentState!.validate()) {
      final pedido = Pedido(
        id: widget.pedido?.id,
        clienteId: int.parse(clienteIdCtrl.text),
        total: detalles.fold(0, (suma, d) => suma + (d.cantidad * d.precioUnitario)),
        estado: estadoCtrl.text.trim(),
        isActive: isActive,
        detalles: detalles,
      );

      final pedidoProvider = context.read<PedidoProvider>();
      bool ok = false;
      try {
        if (widget.pedido == null) {
          final nuevoPedido = await pedidoProvider.agregarPedido(pedido);
          ok = nuevoPedido != null && nuevoPedido.id != null;
        } else {
          ok = await pedidoProvider.updatePedido(pedido);
        }
      } catch (e) {
        ok = false;
      }

      if (!mounted) return;
      if (ok) {
        context.pop(true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al guardar el pedido')),
        );
      }
    }
  }

  @override
  void dispose() {
    clienteIdCtrl.dispose();
    estadoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pedido == null ? 'Nuevo Pedido' : 'Editar Pedido'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: clienteIdCtrl,
                decoration: const InputDecoration(labelText: 'ID Cliente'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Requerido' : null,
              ),
              TextFormField(
                controller: estadoCtrl,
                decoration: const InputDecoration(labelText: 'Estado'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Requerido' : null,
              ),
              SwitchListTile(
                value: isActive,
                onChanged: (val) => setState(() => isActive = val),
                title: const Text('Activo'),
              ),
              const SizedBox(height: 20),
              const Text('Detalles del Pedido', style: TextStyle(fontWeight: FontWeight.bold)),
              ...detalles.asMap().entries.map((entry) {
                final index = entry.key;
                final detalle = entry.value;
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        TextFormField(
                          initialValue: detalle.productoId.toString(),
                          decoration: const InputDecoration(labelText: 'ID Producto'),
                          keyboardType: TextInputType.number,
                          onChanged: (val) => detalle.productoId = int.tryParse(val) ?? 0,
                        ),
                        TextFormField(
                          initialValue: detalle.cantidad.toString(),
                          decoration: const InputDecoration(labelText: 'Cantidad'),
                          keyboardType: TextInputType.number,
                          onChanged: (val) => detalle.cantidad = int.tryParse(val) ?? 1,
                        ),
                        TextFormField(
                          initialValue: detalle.precioUnitario.toString(),
                          decoration: const InputDecoration(labelText: 'Precio Unitario'),
                          keyboardType: TextInputType.number,
                          onChanged: (val) => detalle.precioUnitario = double.tryParse(val) ?? 0.0,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => eliminarDetalle(index),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              TextButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Agregar Detalle'),
                onPressed: agregarDetalle,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: guardar,
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
