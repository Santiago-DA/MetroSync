import 'package:flutter/material.dart';
import 'DealsPage.dart';
class HomePage extends StatelessWidget {
  final VoidCallback onMailPressed;
  final List<Map<String, dynamic>> comments = [
    {
      'title': 'Título del Comentario 1',
      'text': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      'label': 'Crítica', // Etiqueta
    },
    {
      'title': 'Título del Comentario 2',
      'text': 'Fusce ut auctor urna. Mauris eu risus vel tortor vehicula ornare.',
      'label': 'Ayuda', // Etiqueta
    },
    {
      'title': 'Título del Comentario 3',
      'text': 'Vivamus lacinia odio vitae vestibulum vestibulum.',
      'label': 'Sugerencia', // Etiqueta
    },
    {
      'title': 'Título del Comentario 4',
      'text': 'Cras ultricies ligula sed magna dictum porta.',
      'label': 'Elogio', // Etiqueta
    },
    {
      'title': 'Título del Comentario 5',
      'text': 'Pellentesque in ipsum id orci porta dapibus.',
      'label': 'Crítica', // Etiqueta
    },
    {
      'title': 'Título del Comentario 6',
      'text': 'Nulla quis lorem ut libero malesuada feugiat.',
      'label': 'Ayuda', // Etiqueta
    },
  ];

  HomePage({
    super.key,
    required this.onMailPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('MetroSync', style: theme.textTheme.titleSmall),
        backgroundColor: colors.primary,
        actions: [
          IconButton(
            icon: Icon(Icons.mail, color: colors.inversePrimary),
            onPressed: onMailPressed,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Carrusel de imágenes
          SizedBox(
            width: 306,
            height: 164,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: PageView(
                children: [
                  _buildImageContainer(context, 'assets/images/imagen1.jpg'),
                  _buildImageContainer(context, 'assets/images/imagen2.jpg'),
                  _buildImageContainer(context, 'assets/images/imagen3.jpg'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Barra de búsqueda
          TextField(
            cursorColor: colors.inversePrimary,
            decoration: InputDecoration(
              hintText: 'Buscar',
              hintStyle: theme.textTheme.bodyMedium,
              prefixIcon: Icon(Icons.search, color: colors.inversePrimary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: colors.secondary),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Filtros
          Row(
            children: [
              // Ícono de filtro fuera del botón de Etiquetas
              Icon(Icons.filter_list, color: colors.inversePrimary),
              const SizedBox(width: 8),
              // Botón de Etiquetas
              ElevatedButton(
                onPressed: () {
                  print('Etiquetas presionado');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text('Etiquetas', style: theme.textTheme.bodyMedium),
              ),
              const SizedBox(width: 16),
              // Ícono de reloj fuera del botón de Recientes
              Icon(Icons.access_time, color: colors.inversePrimary),
              const SizedBox(width: 8),
              // Botón de Recientes
              ElevatedButton(
                onPressed: () {
                  print('Recientes presionado');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text('Recientes', style: theme.textTheme.bodyMedium),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Comentarios
          ...comments.map((comment) => Column(
            children: [
              // Caja de comentarios
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8), // Márgenes invisibles
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    // Contenido del comentario
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // Ícono de persona a la izquierda del título
                            Icon(Icons.account_circle, size: 24, color: colors.inversePrimary),
                            const SizedBox(width: 8),
                            Text(
                              comment['title'] as String,
                              style: theme.textTheme.displayMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          comment['text'] as String,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    // Etiqueta en la esquina superior derecha
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: colors.secondary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          comment['label'] as String,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colors.inversePrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 24),
            ],
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildImageContainer(BuildContext context, String imagePath) {
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        // Navegar a la página Deals
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DealsPage()),
        );
      },
      child: Container(
        width: 306,
        height: 164,
        decoration: BoxDecoration(
          color: colors.primary,
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}


