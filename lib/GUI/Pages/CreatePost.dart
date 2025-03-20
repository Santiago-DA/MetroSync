import 'package:flutter/material.dart';
import 'package:metrosync/User/Current.dart';
import 'package:metrosync/User/User.dart';
import '../../MainFeed/Post.dart';

List<String> _labels = ["Critica", "Ayuda", "Sugerencia", "Idea"];

class CreatePostPage extends StatefulWidget {
  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Get the current theme
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Crear Publicación',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
        ),
        centerTitle: true,
        backgroundColor: colors.primary,
        foregroundColor: colors.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title Field
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: "Título",
                labelStyle: theme.textTheme.bodyMedium,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: colors.secondary),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: colors.primary),
                ),
              ),
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),

            // Description Field
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: "Descripción",
                labelStyle: theme.textTheme.bodyMedium,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: colors.secondary),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: colors.primary),
                ),
              ),
              style: theme.textTheme.bodyLarge,
              maxLines: 5, // Allow multiple lines
            ),
            const SizedBox(height: 20),

            // Label Dropdown
            DropdownButtonFormField<String>(
              value: _selectedLabel,
              decoration: InputDecoration(
                labelText: "Label",
                labelStyle: theme.textTheme.bodyMedium,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: colors.secondary),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: colors.primary),
                ),
              ),
              items: _labels.map((String label) {
                return DropdownMenuItem<String>(
                  value: label,
                  child: Text(
                    label,
                    style: theme.textTheme.bodyLarge,
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedLabel = newValue; // Update the selected label
                });
              },
            ),
            const SizedBox(height: 20),

            // Create Button
            ElevatedButton(
              onPressed: () async {
                User? currentUser = Current().currentUser;
                if (_titleController.text.isEmpty ||
                    _descriptionController.text.isEmpty ||
                    _selectedLabel == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Por favor, completa todos los campos",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colors.inversePrimary,
                        ),
                      ),
                      backgroundColor: colors.error,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                  return;
                }

                Post post = Post(
                  currentUser?.getusername(),
                  _titleController.text,
                  _descriptionController.text,
                  _selectedLabel ?? '',
                );
                await post.insertPostInDB();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Post creado con éxito",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colors.inversePrimary,
                      ),
                    ),
                    backgroundColor: colors.primary,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "Crear",
                style: theme.textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}