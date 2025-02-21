import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final VoidCallback onMailPressed;

  const HomePage({
    super.key,
    required this.onMailPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Using titleMedium from lightMode theme for the title
            Text(
              'Página de Inicio',
              style: Theme.of(context).textTheme.titleMedium, // Title style from lightMode
            ),
            const SizedBox(height: 20),

            // ElevatedButton using the defined elevated button style from lightMode
            ElevatedButton(
              onPressed: onMailPressed,
              child: Text(
                'Objetos Perdidos',

              ),
            ),
          ],
        ),
      ),
    );
  }
}
