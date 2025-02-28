import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  final _registerFormKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Registrate",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                //Formulario
                const SizedBox(height: 20),
                Form(
                  key: _registerFormKey,
                  child: Column(
                    children: [
                      //Nombre
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Nombre',
                          labelStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                          floatingLabelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        ),
                        style: TextStyle(color: Colors.black),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu nombre';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      //Apellido
                      TextFormField(
                        controller: _lastNameController,
                        decoration: InputDecoration(
                          labelText: 'Apellido',
                          labelStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                          floatingLabelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        ),
                        style: TextStyle(color: Colors.black),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu apellido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      //username
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'username',
                          labelStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                          floatingLabelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        ),
                        style: TextStyle(color: Colors.black),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu username';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      //email
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Correo electronico',
                          labelStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                          floatingLabelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        ),
                        style: TextStyle(color: Colors.black),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu correo electronico';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      //clave
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          labelStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                          floatingLabelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        ),
                        style: TextStyle(color: Colors.black),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu contraseña';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      //confirmar clave?
                      TextFormField(
                        controller: _confirmPasswordController,
                        decoration: InputDecoration(
                          labelText: 'Confirmar contraseña',
                          labelStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                          floatingLabelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        ),
                        style: TextStyle(color: Colors.black),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa la misma contraseña';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    print("boton registro presionado");
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context)
                        .colorScheme
                        .surface, // Color del texto
                  ),
                  child: const Text('Registrar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
