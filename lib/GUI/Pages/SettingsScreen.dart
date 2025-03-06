import 'package:flutter/material.dart';
import 'package:metrosync/User/Current.dart';

import '../../User/User.dart' show User;
import 'loginScreen.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  void _showConfirmationDialog(BuildContext context, String dialogText) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(dialogText),
          actions: [
            TextButton(
              onPressed: () {
                Current().logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LogInPage()),
                  (route) => false, // Remove all routes
                );
              },
              child: Text("Confirmar"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancelar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
        appBar: AppBar(
          title: Text('Configuraciones', style: theme.textTheme.displayMedium),
          centerTitle: true,
          backgroundColor: colors.primary,
          foregroundColor: colors.inversePrimary,
        ),
        body: ListView(
          padding: const EdgeInsets.all(8),
          children: [
            ListTile(
              leading: Icon(Icons.logout, color: colors.inversePrimary),
              title: Text("Cerrar Sesión"),
              onTap: () {
                _showConfirmationDialog(context, "Cerrar Sesión");
              },
            ),
          ],
        ));
  }
}
