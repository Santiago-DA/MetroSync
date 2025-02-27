import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registro')),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Aquí irían los campos del formulario de registro
            Text('Formulario de registro...'),
          ],
        ),
      ),
    );
  }
}
