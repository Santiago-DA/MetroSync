import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:metrosync/ViewModel/ViewModel.dart';
import 'package:metrosync/lost_item/lost_item.dart';
import 'CreateLostItem.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LostItemsPage extends StatefulWidget {
  const LostItemsPage({super.key});

  @override
  State<LostItemsPage> createState() => _LostItemsPageState();
}

class _LostItemsPageState extends State<LostItemsPage> {
  final TextEditingController _searchController = TextEditingController();
  List<LostItem> _allItems = [];
  List<LostItem> _filteredItems = [];
  bool _isLoading = true;
  bool _hasError = false;
  int _currentPage = 0;
  final int _itemsPerPage = 10;
  String _selectedTag = 'Todos';
  final List<String> _availableTags = [
    'Todos',
    'Electrónica',
    'Documentos',
    'Ropa',
    'Accesorios',
    'Otros'
  ];

  @override
  void initState() {
    super.initState();
    _loadItems();
    _searchController.addListener(_filterItems);
  }

  Future<void> _loadItems() async {
    try {
      final lostItem = LostItem(
        id: '',
        title: '',
        tag: '',
        tagColor: '',
        imageUrl: '',
      );
      
      List<LostItem> items = await lostItem.cargarnBD(100);
      
      setState(() {
        _allItems = items;
        _filteredItems = _allItems
          .where(_matchesSearch)
          .take((_currentPage + 1) * _itemsPerPage)
          .toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Error cargando objetos: $e');
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  bool _matchesSearch(LostItem item) {
    final query = _searchController.text.toLowerCase();
    return item.title.toLowerCase().contains(query) && 
          (_selectedTag == 'Todos' || item.tag == _selectedTag);
  }

  void _filterItems() {
    setState(() {
      _filteredItems = _allItems
          .where(_matchesSearch)
          .take((_currentPage + 1) * _itemsPerPage)
          .toList();
    });
  }

  void _loadMoreItems() {
    setState(() {
      _currentPage++;
      _filteredItems = _allItems
          .where(_matchesSearch)
          .take((_currentPage + 1) * _itemsPerPage)
          .toList();
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

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Objetos perdidos",
          style: theme.textTheme.titleLarge?.copyWith(color: Colors.white),
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
              child: _buildContent(theme, colors),
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

  Widget _buildContent(ThemeData theme, ColorScheme colors) {
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

    if (_filteredItems.isEmpty) {
      return Center(
        child: Text(
          'No se encontraron objetos',
          style: theme.textTheme.bodyLarge?.copyWith(
              color: colors.onSurface.withOpacity(0.6)),
        ),
      );
    }

    return ListView.separated(
      itemCount: _filteredItems.length + 1,
      separatorBuilder: (context, index) => const Divider(height: 30),
      itemBuilder: (context, index) {
        if (index == _filteredItems.length) {
          return _buildLoadMoreButton();
        }
        final item = _filteredItems[index];
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
        style: theme.textTheme.titleLarge?.copyWith(
          color: Colors.black, // Color negro fijo
          decoration: item.claimed 
            ? TextDecoration.lineThrough 
            : null,
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
            Row(
              children: [
                Icon(
                  item.claimed ? Icons.check_circle : Icons.error,
                  color: item.claimed ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: 8),
                Text(
                  item.claimed ? 'RECLAMADO' : 'NO RECLAMADO',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: item.claimed ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  item.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image_not_supported, 
                            size: 40, 
                            color: Colors.grey[500]),
                        Text('Imagen no disponible', 
                            style: TextStyle(color: Colors.grey[500])),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: Icon(item.claimed ? Icons.check : Icons.report_problem,
                    color: Colors.white),
                label: Text(
                  item.claimed ? 'Ya reclamado' : 'Marcar como reclamado',
                  style: const TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: item.claimed ? Colors.grey : colors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: item.claimed ? null : () => _handleClaim(item),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadMoreButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: ElevatedButton(
        onPressed: _loadMoreItems,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        ),
        child: const Text('Cargar más objetos'),
      ),
    );
  }

  void _handleClaim(LostItem item) async {
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