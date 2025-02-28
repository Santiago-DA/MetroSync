import 'package:flutter/material.dart';
import 'RegisterPage.dart';
import 'homeScreen.dart';
import 'package:provider/provider.dart';
import 'package:metrosync/ViewModel/ViewModel.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  LogInPageState createState() => LogInPageState();
}

class LogInPageState extends State<LogInPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<VM>(context, listen: false);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<VM>(
            builder: (context, vm, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Inicio de sesión',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 20),

                  // Mostrar mensaje de error
                  if (vm.errorMessage != null)
                    Text(
                      vm.errorMessage!,
                      style: TextStyle(color: Colors.red),
                    ),
                  const SizedBox(height: 10),

                  // Formulario
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Username input field
                        TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: 'Username',
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
                        const SizedBox(height: 20),

                        // Password input field
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
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
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Login button
                  if (vm.isLoading)
                    CircularProgressIndicator()
                  else
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final success = await vm.logIn(
                            _usernameController.text,
                            _passwordController.text,
                          );

                          if (success) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeScreen()),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Theme.of(context)
                            .colorScheme
                            .surface, // Color del texto
                      ),
                      child: const Text('Iniciar sesión'),
                    ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterScreen()),
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        text: "¿No tienes cuenta? ",
                        style: Theme.of(context).textTheme.labelSmall,
                        children: <TextSpan>[
                          TextSpan(
                            text: "Registrate",
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary),
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
}