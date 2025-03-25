import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:metrosync/ViewModel/ViewModel.dart';

class CreateLostItem extends StatefulWidget {
  const CreateLostItem({super.key});

  @override
  State<CreateLostItem> createState() => _CreateLostItemState();
}

class _CreateLostItemState extends State<CreateLostItem> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _tagController = TextEditingController();
  File? _imageFile;
  bool _isLoading = false;

  final List<String> _tags = ['Electrónica', 'Documentos', 'Ropa', 'Accesorios', 'Otros'];
  String _selectedTag = 'Electrónica';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors.primary,
        title: Text(
          "Reportar Objeto Perdido",
          style: theme.textTheme.labelLarge,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Input
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Título',
                    labelStyle: theme.textTheme.bodyLarge?.copyWith(color: colors.secondary),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: colors.primary),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El título es obligatorio';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Tag Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedTag,
                  items: _tags.map((tag) {
                    return DropdownMenuItem<String>(
                      value: tag,
                      child: Text(tag, style: theme.textTheme.bodyLarge),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedTag = value ?? 'Electrónica';
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Categoría',
                    labelStyle: theme.textTheme.bodyLarge?.copyWith(color: colors.secondary),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: colors.primary),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Image Picker
                GestureDetector(
                  onTap: _pickImage,
                  child: _imageFile == null
                      ? Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: colors.secondary),
                      borderRadius: BorderRadius.circular(8),
                      color: colors.surfaceVariant,
                    ),
                    child: Center(
                      child: Text(
                        'Seleccionar Imagen',
                        style: theme.textTheme.bodyLarge?.copyWith(color: colors.onSurface),
                      ),
                    ),
                  )
                      : Image.file(
                    _imageFile!,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),

                // Submit Button
                _isLoading
                    ? Center(
                  child: CircularProgressIndicator(
                    color: colors.primary,
                  ),
                )
                    : ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Crear Objeto Perdido',
                    style: theme.textTheme.labelMedium?.copyWith(color: colors.onPrimary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      final vm = Provider.of<VM>(context, listen: false);

      // Call the createItem method from VM
      bool success = await vm.crearItem(
        _titleController.text,
        _selectedTag,
        _imageFile!,
      );

      setState(() {
        _isLoading = false;
      });

      if (success) {
        // Show success message and navigate back
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Objeto creado exitosamente')),
        );
        Navigator.pop(context);
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hubo un error al crear el objeto')),
        );
      }
    }
  }
}
