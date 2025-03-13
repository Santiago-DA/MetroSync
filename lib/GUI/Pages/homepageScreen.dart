import 'package:flutter/material.dart';
import 'package:metrosync/GUI/Pages/CreatePost.dart';
import 'package:metrosync/GUI/Pages/PostCard.dart';
import 'DealsPage.dart';

class HomePage extends StatelessWidget {
  final VoidCallback onMailPressed;
  final VoidCallback onhandpressed;

  HomePage({
    super.key,
    required this.onMailPressed,
    required this.onhandpressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 4),
              Image.asset('assets/images/logo_solo.png'),
              const SizedBox(width: 8),
              Text('MetroSync', style: theme.textTheme.titleSmall),
            ],
          ),
          backgroundColor: colors.surface,
          actions: [
            // Nuevo botón de handshake
            IconButton(
              icon: Icon(Icons.handshake, color: colors.inversePrimary),
              onPressed: onhandpressed, // Usar la nueva función
            ),

            const SizedBox(width: 8),

            IconButton(
              icon: Icon(Icons.mail, color: colors.inversePrimary),
              onPressed: onMailPressed,
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Divider(thickness: 5, color: theme.colorScheme.secondary),
          const SizedBox(height: 5),
          // Carrusel de imágenes
          Container(
            width: 306,
            height: 175,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary, // Color del tema
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: PageView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildImageContainer(
                      context, 'assets/images/advertisement_hollyshakes.webp'),
                  _buildImageContainer(
                      context, 'assets/images/anuncio_granier.webp'),
                  _buildImageContainer(
                      context, 'assets/images/anuncio_pepperonis.webp'),
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
                child: Text('Etiquetas', style: theme.textTheme.labelMedium),
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
                child: Text('Recientes', style: theme.textTheme.labelMedium),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Posts
          PostWidget(
              userName: "Test user",
              title: "test Tittle",
              description: "test decripcion",
              contentLabel: "test label",
              likes: 20,
              comments: 20),
          PostWidget(
              userName: "Test user2",
              title: "test Tittle2",
              description: "test decripcion2",
              contentLabel: "test label2",
              likes: 350,
              comments: 10),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreatePostPage()),
          );
        },
        child: Icon(
          Icons.add,
          fill: 1.0,
        ),
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
          color: colors.surface,
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
