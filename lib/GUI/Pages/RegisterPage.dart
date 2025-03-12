import 'package:flutter/material.dart';
import 'loginScreen.dart';
import 'homeScreen.dart';
import 'package:provider/provider.dart';
import 'package:metrosync/ViewModel/ViewModel.dart';

class RegisterScreen extends StatelessWidget {
  final _registerFormKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  RegisterScreen({super.key});


  void _showError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Error al registrarse.'),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    


    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Consumer<VM>(
          builder: (context, vm, child) {
            return Column(

              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Section
                Column(
                  children: [
                    Icon(Icons.person_add_alt_1,
                      size: 64,
                      color: Theme
                          .of(context)
                          .colorScheme
                          .primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Regístrate",
                      style: Theme
                          .of(context)
                          .textTheme
                          .displayLarge
                          ?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme
                            .of(context)
                            .colorScheme
                            .primary,
                      ),
                    ),
                    const SizedBox(height: 8),

                  ],
                ),
                const SizedBox(height: 32),

                // Form Section
                Form(
                  key: _registerFormKey,
                  child: Column(
                    children: [
                      _buildTextFormField(
                        controller: _nameController,
                        label: 'Nombre',
                        context: context,
                        validator: (value) =>
                        value?.isEmpty ?? true
                            ? 'Por favor ingresa tu nombre'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      _buildTextFormField(
                        controller: _lastNameController,
                        label: 'Apellido',
                        context: context,
                        validator: (value) =>
                        value?.isEmpty ?? true
                            ? 'Por favor ingresa tu apellido'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      _buildTextFormField(
                        controller: _usernameController,
                        label: 'Nombre de usuario',
                        context: context,
                        validator: (value) =>
                        value?.isEmpty ?? true
                            ? 'Por favor ingresa tu username'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      _buildTextFormField(
                        controller: _emailController,
                        label: 'Correo electrónico',
                        context: context,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) =>
                        value?.isEmpty ?? true
                            ? 'Por favor ingresa tu correo electrónico'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      _buildTextFormField(
                        controller: _passwordController,
                        label: 'Contraseña',
                        context: context,
                        obscureText: true,
                        validator: (value) =>
                        value?.isEmpty ?? true
                            ? 'Por favor ingresa tu contraseña'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      _buildTextFormField(
                        controller: _confirmPasswordController,
                        label: 'Confirmar contraseña',
                        obscureText: true,
                        context: context,
                        validator: (value) {
                          if (value?.isEmpty ?? true)
                            return 'Confirma tu contraseña';
                          if (value != _passwordController.text)
                            return 'Las contraseñas no coinciden';
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // if (vm.errorMessage != null)
                //   Padding(
                //     padding: const EdgeInsets.only(bottom: 16),
                //     child: Text(
                //       vm.errorMessage!,
                //       style: TextStyle(
                //         color: Theme.of(context).colorScheme.error,
                //         fontWeight: FontWeight.w500,
                //       ),
                //       textAlign: TextAlign.center,
                //     ),
                //   ),


                if (vm.isLoading)
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: CircularProgressIndicator(
                      color: Theme
                          .of(context)
                          .colorScheme
                          .primary,
                    ),
                  )
                else
                  ElevatedButton(
                    onPressed: () => _submitForm(context, vm),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Theme
                          .of(context)
                          .colorScheme
                          .primary,
                      foregroundColor: Theme
                          .of(context)
                          .colorScheme
                          .onPrimary,
                    ),
                    child: const Text('REGISTRARSE',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),

                const SizedBox(height: 24),

                // Login Link
                TextButton(
                  onPressed: () =>
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LogInPage()),
                      ),
                  child: RichText(
                    text: TextSpan(
                      text: "¿Ya tienes cuenta? ",
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                      children: [
                        TextSpan(
                          text: "Inicia sesión",
                          style: TextStyle(
                            color: Theme
                                .of(context)
                                .colorScheme
                                .primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
          ),

        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required context,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.grey[900],
          fontSize: 14,
            fontWeight: FontWeight.normal,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey.shade200,
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 20, vertical: 18),
      ),
      style: TextStyle(
        color: Colors.grey.shade800,
        fontWeight: FontWeight.w500,
      ),
      validator: validator,
    );
  }

  void _submitForm(BuildContext context, VM vm) async {
    if (_registerFormKey.currentState!.validate()) {
      final success = await vm.register(
        _usernameController.text,
        _passwordController.text,
        _emailController.text,
        _nameController.text,
        _lastNameController.text,
      );

      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        _showError(context);
        _usernameController.clear();
        _passwordController.clear();
        _confirmPasswordController.clear();
        _emailController.clear();
        _nameController.clear();
        _lastNameController.clear();
      }


    }


  }
}