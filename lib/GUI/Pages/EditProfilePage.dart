import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para los inputFormatters
class EditProfilePage extends StatefulWidget {
  final String currentName;
  final String currentLastName;
  final String currentDescription;
  final String currentUsername;
  final Function(String, String, String) onSave;

  const EditProfilePage({
    super.key,
    required this.currentName,
    required this.currentLastName,
    required this.currentDescription,
    required this.currentUsername,
    required this.onSave,
  });

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _lastNameController;
  late TextEditingController _descriptionController;
  late TextEditingController _usernameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
    _nameController.addListener(() {
    if(mounted) setState(() {});
  });
    _lastNameController = TextEditingController(text: widget.currentLastName);
    _descriptionController = TextEditingController(text: widget.currentDescription);
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
            onPressed: () async{
              widget.onSave(_nameController.text,_lastNameController.text,_descriptionController.text );
              await Future.delayed(const Duration(seconds: 2));
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              left: 16,
              right: 16,
              top: 16
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - MediaQuery.of(context).viewInsets.bottom
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                        labelText: 'Nombre',
                        helperText: 'Máximo 16 caracteres',
                        helperStyle: TextStyle(color: Colors.grey),
                      ),
                      maxLength: 16,
                      buildCounter: (BuildContext context, { 
                        required int currentLength,
                        required int? maxLength,
                        required bool isFocused,
                      }) => Text(
                        '$currentLength/$maxLength',
                        style: TextStyle(
                          color: currentLength > 16 ? Colors.red : Colors.grey,
                        ),
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(16),
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Zá-úÁ-Ú ]')),
                      ],
                    ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _lastNameController,
                    decoration: InputDecoration(labelText: 'Apellido'),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(labelText: 'Usuario'),
                    enabled: false,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(labelText: 'Descripción'),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }


  void _changeProfileImage() {
    // Lógica para cambiar la imagen de perfil
    print('Cambiar imagen de perfil');
  }
}