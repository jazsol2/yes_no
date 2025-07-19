import 'package:flutter/material.dart';
import 'package:myapp/models/client_model.dart';
import 'package:myapp/services/client_service.dart';
import 'package:go_router/go_router.dart';

class ClienteFormScreen extends StatefulWidget {
  final Cliente? cliente;

  const ClienteFormScreen({this.cliente, super.key, int? clienteId});

  @override
  State<ClienteFormScreen> createState() => _ClienteFormScreenState();
}

class _ClienteFormScreenState extends State<ClienteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ClienteService clienteService = ClienteService();

  late TextEditingController nombreCtrl;
  late TextEditingController apellidoCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController telefonoCtrl;
  bool isActive = true;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    nombreCtrl = TextEditingController(text: widget.cliente?.nombre ?? '');
    apellidoCtrl = TextEditingController(text: widget.cliente?.apellido ?? '');
    emailCtrl = TextEditingController(text: widget.cliente?.email ?? '');
    telefonoCtrl = TextEditingController(text: widget.cliente?.telefono ?? '');
    isActive = widget.cliente?.isActive ?? true;
  }

  Future<void> saveCliente() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isSaving = true);

    final cliente = Cliente(
      id: widget.cliente?.id,
      nombre: nombreCtrl.text.trim(),
      apellido: apellidoCtrl.text.trim(),
      email: emailCtrl.text.trim(),
      telefono: telefonoCtrl.text.trim(),
      isActive: isActive,
    );

    bool ok = false;
    try {
      if (widget.cliente == null) {
        final nuevoCliente = await clienteService.createCliente(cliente);
        ok = nuevoCliente.id != null;
      } else {
        ok = await clienteService.updateCliente(cliente);
      }
    } catch (e) {
      ok = false;
    }

    setState(() => isSaving = false);

    if (ok) {
      context.pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar cliente')),
      );
    }
  }

  @override
  void dispose() {
    nombreCtrl.dispose();
    apellidoCtrl.dispose();
    emailCtrl.dispose();
    telefonoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.cliente != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Editar Cliente' : 'Nuevo Cliente')),
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
                controller: apellidoCtrl,
                decoration: const InputDecoration(labelText: 'Apellido'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Ingrese el apellido' : null,
              ),
              TextFormField(
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Ingrese el email';
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) {
                    return 'Email inválido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: telefonoCtrl,
                decoration: const InputDecoration(labelText: 'Teléfono'),
                keyboardType: TextInputType.phone,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Ingrese el teléfono' : null,
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
                      onPressed: saveCliente,
                      child: const Text('Guardar'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
