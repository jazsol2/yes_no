import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/models/product_model.dart';
import 'package:myapp/providers/product_provider.dart';
import 'package:go_router/go_router.dart';

class ProductoFormScreen extends StatefulWidget {
  final Producto? producto;

  const ProductoFormScreen({this.producto, super.key});

  @override
  State<ProductoFormScreen> createState() => _ProductoFormScreenState();
}

class _ProductoFormScreenState extends State<ProductoFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nombreCtrl;
  late TextEditingController precioCtrl;
  late TextEditingController descripcionCtrl;
  late TextEditingController stockCtrl;
  bool isActive = true;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    nombreCtrl = TextEditingController(text: widget.producto?.nombre ?? '');
    precioCtrl = TextEditingController(text: widget.producto?.precio.toString() ?? '');
    descripcionCtrl = TextEditingController(text: widget.producto?.descripcion ?? '');
    stockCtrl = TextEditingController(text: widget.producto?.stock.toString() ?? '');
    isActive = widget.producto?.isActive ?? true;
  }

  Future<void> saveProducto() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isSaving = true);

    final producto = Producto(
      id: widget.producto?.id,
      nombre: nombreCtrl.text.trim(),
      precio: double.tryParse(precioCtrl.text.trim()) ?? 0,
      descripcion: descripcionCtrl.text.trim(),
      stock: int.tryParse(stockCtrl.text.trim()) ?? 0,
      isActive: isActive,
    );

    bool ok = false;

    try {
      final productoProvider = context.read<ProductoProvider>();
      if (widget.producto == null) {
        await productoProvider.addProducto(producto);
      } else {
        await productoProvider.updateProducto(producto);
      }
      ok = true;
    } catch (e) {
      ok = false;
    }

    setState(() => isSaving = false);

    if (ok) {
      context.pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al guardar producto')),
      );
    }
  }

  @override
  void dispose() {
    nombreCtrl.dispose();
    precioCtrl.dispose();
    descripcionCtrl.dispose();
    stockCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.producto != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Editar Producto' : 'Nuevo Producto')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nombreCtrl,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Ingrese el nombre' : null,
              ),
              TextFormField(
                controller: precioCtrl,
                decoration: const InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Ingrese el precio';
                  if (double.tryParse(v) == null) return 'Precio inválido';
                  return null;
                },
              ),
              TextFormField(
                controller: descripcionCtrl,
                decoration: const InputDecoration(labelText: 'Descripción'),
                maxLines: 3,
              ),
              TextFormField(
                controller: stockCtrl,
                decoration: const InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Ingrese el stock';
                  if (int.tryParse(v) == null) return 'Stock inválido';
                  return null;
                },
              ),
              SwitchListTile(
                title: const Text('Activo'),
                value: isActive,
                onChanged: (v) => setState(() => isActive = v),
              ),
              const SizedBox(height: 20),
              isSaving
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: saveProducto,
                      child: const Text('Guardar'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
