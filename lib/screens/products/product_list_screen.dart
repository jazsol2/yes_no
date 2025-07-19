import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/product_provider.dart';
import 'package:myapp/models/product_model.dart';
import 'package:go_router/go_router.dart';

class ProductoListScreen extends StatefulWidget {
  const ProductoListScreen({super.key});

  @override
  State<ProductoListScreen> createState() => _ProductoListScreenState();
}

class _ProductoListScreenState extends State<ProductoListScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProductos();
  }

  Future<void> _loadProductos() async {
    await context.read<ProductoProvider>().loadProductos();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final productos = context.watch<ProductoProvider>().productos;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.push('/productos/form');
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : productos.isEmpty
              ? const Center(child: Text('No hay productos'))
              : ListView.builder(
                  itemCount: productos.length,
                  itemBuilder: (context, index) {
                    final producto = productos[index];
                    return ListTile(
                      title: Text(producto.nombre),
                      subtitle: Text('\$${producto.precio.toStringAsFixed(2)}'),
                      trailing: Switch(
                        value: producto.isActive,
                        onChanged: (val) async {
                          // Puedes implementar activar/desactivar aquí
                          await context.read<ProductoProvider>().updateProducto(
                            Producto(
                              id: producto.id,
                              nombre: producto.nombre,
                              precio: producto.precio,
                              descripcion: producto.descripcion,
                              stock: producto.stock,
                              isActive: val,
                            ),
                          );
                        },
                      ),
                      onTap: () {
                        context.push('/productos/form', extra: producto);
                      },
                    );
                  },
                ),
    );
  }
}
