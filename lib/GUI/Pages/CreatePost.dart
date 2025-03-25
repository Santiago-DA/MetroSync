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
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Crear Publicación',
          style: textTheme.titleSmall?.copyWith(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: colors.primary,
        foregroundColor: colors.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 30),

            // Title TextField
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: "Título",
                hintText: "Ingrese el título",
                filled: true,
                fillColor: colors.surface.withOpacity(0.1),
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: colors.primary,
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: colors.secondary.withOpacity(0.5),
                    width: 1,
                  ),
                ),
                suffixIcon: Icon(
                  Icons.edit,
                  color: colors.secondary,
                ),
              ),
              style: textTheme.bodyLarge,
            ),

            SizedBox(height: 30),

            // Description TextField
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: "Descripción",
                hintText: "Ingrese la descripción",
                filled: true,
                fillColor: colors.surface.withOpacity(0.1),
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: colors.primary,
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: colors.secondary.withOpacity(0.5),
                    width: 1,
                  ),
                ),
                suffixIcon: Icon(
                  Icons.edit,
                  color: colors.secondary,
                ),
              ),
              style: textTheme.bodyLarge,
              maxLines: 5,
            ),

            SizedBox(height: 30),

            // Label Dropdown
            DropdownButtonFormField<String>(
              value: _selectedLabel,
              decoration: InputDecoration(
                labelText: "Label",
                filled: true,
                fillColor: colors.surface.withOpacity(0.1),
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: colors.primary,
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: colors.secondary.withOpacity(0.5),
                    width: 1,
                  ),
                ),
              ),
              items: _labels.map((String label) {
                return DropdownMenuItem<String>(
                  value: label,
                  child: Text(
                    label,
                    style: textTheme.bodyLarge,
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedLabel = newValue; // Update the selected label
                });
              },
            ),

            SizedBox(height: 20),

            // Create Button
            TextButton(
              onPressed: () async {
                User? currentUser = Current().currentUser;
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
                      style: textTheme.bodyMedium?.copyWith(color: colors.onSurface),
                    ),
                    duration: Duration(seconds: 2),
                    backgroundColor: colors.surface,
                  ),
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: colors.primary,
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "Crear",
                style: textTheme.labelLarge?.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}