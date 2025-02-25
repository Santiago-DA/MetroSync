import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  final String currentName;
  final String currentUsername;
  final Function(String, String) onSave;

  const EditProfilePage({
    super.key,
    required this.currentName,
    required this.currentUsername,
    required this.onSave,
  });

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _usernameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
    _usernameController = TextEditingController(text: widget.currentUsername);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Perfil', style: theme.textTheme.displayMedium),
        actions: [
          IconButton(
            icon: Icon(Icons.save, color: colors.inversePrimary),
            onPressed: () {
              widget.onSave(_nameController.text, _usernameController.text);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => _changeProfileImage(),
              child: CircleAvatar(
                radius: 50,
                backgroundColor: colors.primary,
                child: Icon(Icons.camera_alt, 
                  size: 40, 
                  color: colors.inversePrimary),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nombre completo',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Nombre de usuario',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _changeProfileImage() {
    // Lógica para cambiar la imagen de perfil
    print('Cambiar imagen de perfil');
  }
}