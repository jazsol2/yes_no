// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:myapp/models/product_model.dart';
import 'package:myapp/screens/products/product_form_screen.dart';
import 'package:myapp/services/product_service.dart';

class ProductosScreen extends StatefulWidget {
  const ProductosScreen({super.key});

  @override
  _ProductosScreenState createState() => _ProductosScreenState();
}

class _ProductosScreenState extends State<ProductosScreen> {
  final ProductoService productoService = ProductoService();
  List<Producto> productos = [];

  @override
  void initState() {
    super.initState();
    _loadProductos();
  }

  Future<void> _loadProductos() async {
    final data = await productoService.getProductos();
    setState(() {
      productos = data;
    });
  }

  void _goToForm({Producto? producto}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductoForm(producto: producto),
      ),
    );
    if (result == true) {
      _loadProductos();
    }
  }

  void _toggleEstado(Producto producto) async {
    await productoService.deactivateProducto(producto.id);
    _loadProductos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Productos')),
      body: ListView.builder(
        itemCount: productos.length,
        itemBuilder: (context, index) {
          final p = productos[index];
          return ListTile(
            title: Text(p.nombre),
            subtitle: Text('Precio: \$${p.precio.toStringAsFixed(2)} - Stock: ${p.stock}'),
            trailing: IconButton(
              icon: Icon(p.isActive ? Icons.check_circle : Icons.cancel, color: p.isActive ? Colors.green : Colors.red),
              onPressed: () => _toggleEstado(p),
            ),
            onTap: () => _goToForm(producto: p),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _goToForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
