import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'CreateLostItem.dart';
import 'package:metrosync/ViewModel/ViewModel.dart';
import 'package:metrosync/lost_item/lost_item.dart';
import 'dart:convert';

class LostItemsPage extends StatefulWidget {
  const LostItemsPage({super.key});

  @override
  State<LostItemsPage> createState() => _LostItemsPageState();
}

class _LostItemsPageState extends State<LostItemsPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  bool _hasError = false;
  String _selectedTag = 'Todos';
  final List<String> _availableTags = [
    'Todos',
    'Electrónica',
    'Documentos',
    'Ropa',
    'Accesorios',
    'Otros'
  ];
  List<LostItem> filteredItems = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
    _searchController.addListener(_filterItems);
  }

  Future<void> _loadItems() async {
    try {
      final vm = Provider.of<VM>(context, listen: false);
      await vm.loaditemfromBD();

      setState(() {
        _isLoading = false;
        filteredItems = List.from(vm.lostitem);
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  void _filterItems() {
    final vm = Provider.of<VM>(context, listen: false);
    final searchText = _searchController.text.toLowerCase();

    setState(() {
      filteredItems = vm.lostitem.where((item) {
        bool matchesTag = _selectedTag == 'Todos' || item.tag == _selectedTag;
        bool matchesSearch = item.title.toLowerCase().contains(searchText);
        return matchesTag && matchesSearch;
      }).toList();
    });
  }

  void _updateTagFilter(String? newTag) {
    setState(() {
      _selectedTag = newTag ?? 'Todos';
      _filterItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final vm = Provider.of<VM>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Objetos perdidos",
          style: theme.textTheme.titleSmall?.copyWith(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: colors.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateLostItem()),
            ).then((_) => _loadItems()),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchBar(colors, theme),
            const SizedBox(height: 20),
            _buildTagFilter(theme),
            const SizedBox(height: 20),
            Expanded(
              child: _buildContent(theme, colors, vm),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(ColorScheme colors, ThemeData theme) {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Buscar por título...',
        prefixIcon: Icon(Icons.search, color: colors.inversePrimary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: colors.secondary),
        ),
        filled: true,
        fillColor: colors.surfaceVariant,
      ),
    );
  }

  Widget _buildTagFilter(ThemeData theme) {
    return DropdownButtonFormField<String>(
      value: _selectedTag,
      items: _availableTags.map((tag) => DropdownMenuItem(
        value: tag,
        child: Text(tag, style: theme.textTheme.bodyLarge),
      )).toList(),
      onChanged: _updateTagFilter,
      decoration: InputDecoration(
        labelText: 'Filtrar por categoría',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      dropdownColor: theme.colorScheme.surface,
    );
  }

  Widget _buildContent(ThemeData theme, ColorScheme colors, VM vm) {
    if (_isLoading) {
      return Center(
        child: SpinKitFadingCube(
          color: colors.primary,
          size: 50.0,
        ),
      );
    }

    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: colors.error, size: 50),
            const SizedBox(height: 20),
            Text('Error al cargar los datos',
                style: theme.textTheme.headlineSmall),
          ],
        ),
      );
    }

    if (filteredItems.isEmpty) {
      return Center(
        child: Text(
          'No se encontraron objetos',
          style: theme.textTheme.bodyLarge?.copyWith(
              color: colors.onSurface.withOpacity(0.6)),
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        final item = filteredItems[index];
        return _buildItemCard(item, theme, colors);
      },
    );
  }

  Widget _buildItemCard(LostItem item, ThemeData theme, ColorScheme colors) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _getTagColor(item.tagColor),
                    shape: BoxShape.circle,
                    border: Border.all(color: colors.inversePrimary),
                  ),
                  child: Icon(
                    _getTagIcon(item.tag),
                    color: colors.onPrimaryContainer,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: colors.onSurface, // Updated text color
                          decoration: item.claimed ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'ID: ${item.id}',
                        style: theme.textTheme.bodySmall?.copyWith(
                            color: colors.onSurface.withOpacity(0.6)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              'Categoría: ${item.tag}',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 10),
            // Display the image from Base64
            if (item.imageBase64.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.memory(
                  base64Decode(item.imageBase64),
                  width: double.infinity,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  item.claimed ? Icons.check_circle : Icons.error,
                  color: item.claimed ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: 8),
                Text(
                  item.claimed ? 'Reclamado' : 'Sin Reclamar',
                  style: theme.textTheme.bodyLarge,
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Button to mark as claimed (only if unclaimed)
            if (!item.claimed)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _handleClaim(item, context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Marcar como Reclamado', style: TextStyle(color: Colors.white)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _handleClaim(LostItem item, context) async {
    try {
      await item.reclamarBD();
      _loadItems();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${item.title} marcado como reclamado'),
          backgroundColor: Colors.green[700],
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red[700],
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Color _getTagColor(String tagColor) {
    switch (tagColor.toLowerCase()) {
      case 'red':
        return Colors.redAccent.withOpacity(0.15);
      case 'blue':
        return Colors.blueAccent.withOpacity(0.15);
      case 'green':
        return Colors.greenAccent.withOpacity(0.15);
      default:
        return Colors.grey.withOpacity(0.15);
    }
  }

  IconData _getTagIcon(String tag) {
    switch (tag.toLowerCase()) {
      case 'electrónica':
        return Icons.electrical_services;
      case 'documentos':
        return Icons.assignment;
      case 'ropa':
        return Icons.checkroom;
      case 'accesorios':
        return Icons.watch;
      default:
        return Icons.category;
    }
  }
}
