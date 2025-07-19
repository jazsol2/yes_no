import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/providers/user_provider.dart';
import 'package:myapp/widgets/custom_button.dart';
import 'package:myapp/widgets/custom_text_field.dart';

class UserFormScreen extends StatefulWidget {
  final User? user;
  const UserFormScreen({super.key, this.user, int? usuarioId});

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final nombreCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      nombreCtrl.text = widget.user!.name ?? '';
      emailCtrl.text = widget.user!.email;
    }
  }

  @override
  void dispose() {
    nombreCtrl.dispose();
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isSaving = true);

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = User(
      id: widget.user?.id ?? 0,
      name: nombreCtrl.text.trim(),
      email: emailCtrl.text.trim(),
      isActive: widget.user?.isActive ?? true,
    );

    try {
      if (widget.user == null) {
        await userProvider.createUser(user, passwordCtrl.text.trim());
      } else {
        await userProvider.updateUser(user);
      }

      context.pop(true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.user != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Editar Usuario' : 'Nuevo Usuario')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                controller: nombreCtrl,
                label: 'Nombre',
                validator: (value) =>
                    value == null || value.isEmpty ? 'Ingrese el nombre' : null,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: emailCtrl,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Ingrese el email';
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Email inválido';
                  }
                  return null;
                },
              ),
              if (!isEdit) ...[
                const SizedBox(height: 12),
                CustomTextField(
                  controller: passwordCtrl,
                  label: 'Contraseña',
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return 'Mínimo 6 caracteres';
                    }
                    return null;
                  },
                ),
              ],
              const SizedBox(height: 20),
              CustomButton(
                text: isSaving ? 'Guardando...' : 'Guardar',
                onPressed: isSaving ? null : _saveUser,
                loading: isSaving,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
