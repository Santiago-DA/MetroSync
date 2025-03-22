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
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Publicación', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white)),
        centerTitle: true,
        backgroundColor: colors.primary,
        foregroundColor: colors.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 30),

            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: "Título",
                hintText: "Ingrese el título",
                filled: true,
                fillColor: Colors.grey.shade200,
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.grey[300]!,
                    width: 1,
                  ),
                ),
                suffixIcon: Icon(
                  Icons.edit,
                  color: Colors.grey[600],
                ),
              ),
            ),

            SizedBox(height: 30),


            //description
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: "Descripcion",
                hintText: "Ingrese la descripcion",
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.grey[300]!,
                    width: 1,
                  ),
                ),
                suffixIcon: Icon(
                  Icons.edit, // Add an edit icon
                  color: Colors.grey[600],
                ),
              ),
              maxLines: 5,
            ),



            SizedBox(height: 30),
            //labels
            DropdownButtonFormField<String>(
              value: _selectedLabel,
              decoration: InputDecoration(

                labelText: "Label",

                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.grey[300]!,
                    width: 1,
                  ),
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
                setState(
                  () {
                    _selectedLabel = newValue; // Update the selected label
                  },
                );
              },
            ),
            SizedBox(height: 20), // Spacing
            TextButton(
                onPressed: () async {
                  User? currentUser = Current().currentUser;
                  Post post = Post(
                      currentUser?.getusername(),
                      _titleController.text,
                      _descriptionController.text,
                      _selectedLabel ?? '');
                  await post.insertPostInDB();
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Post creado con exito"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: Text("Crear")
            ),
          ],
        ),
      ),
    );
  }
}
