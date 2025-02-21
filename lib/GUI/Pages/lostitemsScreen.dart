import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';


class LostItemsPage extends StatelessWidget {
  const LostItemsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const SizedBox.shrink(),
        backgroundColor: Color.fromARGB(0, 255, 255, 255),
      ),
      body: const Center(
        child: Text(
          'Página de Objetos Perdidos',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}