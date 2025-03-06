import 'package:flutter/material.dart';

class Userlist extends StatelessWidget {
  const Userlist({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Usuarios',
          style: TextStyle(
            fontSize: 24.0, // Tamaño de la fuente
            fontWeight: FontWeight.bold, // Peso de la fuente (negrita)
            color: const Color.fromARGB(255, 0, 0, 0), // Color del texto
          ),
        ),
      ),
      body: Center(
        child: Text('Esta es la página de userlist'),
      ),
    );
  }
}