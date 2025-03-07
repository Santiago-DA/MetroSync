import 'package:flutter/material.dart';

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
        title: Text('Crear Publicación', style: theme.textTheme.displayLarge),
        centerTitle: true,
        backgroundColor: colors.primary,
        foregroundColor: colors.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            //tiitle
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: "Titulo",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            //description
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: "Descripción",
                border: OutlineInputBorder(),
              ),
              maxLines: 5, // Allow multiple lines
            ),
            SizedBox(height: 20), // Spacing
            //labels
            DropdownButtonFormField<String>(
              value: _selectedLabel,
              decoration: InputDecoration(
                labelText: "Label",
                border: OutlineInputBorder(),
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
            ElevatedButton(
                onPressed: () {
                  print("hey");
                },
                child: Text("Crear"))
          ],
        ),
      ),
    );
  }
}
