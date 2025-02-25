import 'package:flutter/material.dart';
import "EditProfilePage.dart";

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _nombre = 'Gabriel';
  String _apellido = 'Garcia';
  String _usuario = '@gabgaru';
  String _descripcion = 'Soy Sr abolito majestuoso';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    // Lista de amigos inventada
    final List<String> amigos = [
      'Amigo 1',
      'Amigo 2',
      'Amigo 3',
      'Amigo 4',
    ];

    // Lista de sincronizados inventada
    final List<String> sincronizados = [
      'Sincronizado 1',
      'Sincronizado 2',
      'Sincronizado 3',
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Perfil', style: theme.textTheme.displayMedium),
        centerTitle: true,
        backgroundColor: colors.primary,
        foregroundColor: colors.inversePrimary,
        actions: [
          // Botón de editar perfil
          IconButton(
            icon: Icon(Icons.edit, color: colors.inversePrimary),
            onPressed: _editarPerfil,
              
            
          ),
          // Botón de configuración
          IconButton(
            icon: Icon(Icons.settings, color: colors.inversePrimary),
            onPressed: () {
              print('Configuración presionado');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mover el ícono account_circle más arriba
            Container(
              margin: const EdgeInsets.only(top: 20), // Margen superior para subir el ícono
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center, // Alinear ícono y texto al centro
                children: [
                  // Ícono de cuenta
                  Icon(
                    Icons.account_circle,
                    size: 60, // Tamaño grande
                    color: colors.inversePrimary,
                  ),
                  const SizedBox(width: 16), // Espacio entre el ícono y el texto
                  // Nombre y usuario
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$_nombre $_apellido",
                        style: theme.textTheme.displayLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _usuario,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: colors.inversePrimary.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _descripcion,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: colors.inversePrimary.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Botones de "Amigos" y "Sincronizados"
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Mostrar popup de amigos
                              _mostrarPopupAmigos(context, amigos);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colors.secondary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              'Amigos',
                              style: theme.textTheme.labelSmall?.copyWith(

                              ),
                            ),
                          ),
                          const SizedBox(width: 10), // Espacio entre los botones
                          ElevatedButton(
                            onPressed: () {
                              // Mostrar popup de sincronizados
                              _mostrarPopupSincronizados(context, sincronizados);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colors.secondary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              'Sincronizados',
                              style: theme.textTheme.labelSmall
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Pestañas de "Publicaciones", "Respuestas" y "Objetos"
            DefaultTabController(
              length: 3, // Número de pestañas
              child: Column(
                children: [
                  // Barra de pestañas
                  TabBar(
                    labelColor: colors.inversePrimary,
                    unselectedLabelColor: colors.inversePrimary.withOpacity(0.5),
                    indicatorColor: colors.inversePrimary,
                    labelStyle: theme.textTheme.displayLarge?.copyWith(
                      fontSize: 16, // Reducir el tamaño de fuente
                    ),
                    unselectedLabelStyle: theme.textTheme.displayLarge?.copyWith(
                      fontSize: 14, // Reducir el tamaño de fuente
                    ),
                    tabs: const [
                      Tab(text: 'Publicaciones'),
                      Tab(text: 'Respuestas'),
                      Tab(text: 'Objetos'),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Contenido de las pestañas
                  SizedBox(
                    height: 400, // Altura fija para el contenido de las pestañas
                    child: TabBarView(
                      children: [
                        // Contenido de "Publicaciones"
                        ListView(
                          children: [
                            ListTile(
                              leading: Icon(Icons.post_add, color: colors.inversePrimary),
                              title: Text(
                                'Publicación 1',
                                style: theme.textTheme.displayMedium, // Título con displayMedium
                              ),
                              subtitle: Text(
                                'Descripción de la publicación 1',
                                style: theme.textTheme.bodyLarge, // Descripción con bodyLarge
                              ),
                            ),
                            ListTile(
                              leading: Icon(Icons.post_add, color: colors.inversePrimary),
                              title: Text(
                                'Publicación 2',
                                style: theme.textTheme.displayMedium, // Título con displayMedium
                              ),
                              subtitle: Text(
                                'Descripción de la publicación 2',
                                style: theme.textTheme.bodyLarge, // Descripción con bodyLarge
                              ),
                            ),
                            // Agrega más publicaciones aquí
                          ],
                        ),

                        // Contenido de "Respuestas"
                        ListView(
                          children: [
                            ListTile(
                              leading: Icon(Icons.question_answer, color: colors.inversePrimary),
                              title: Text(
                                'Creacion de Figma',
                                style: theme.textTheme.displayMedium, // Título con displayMedium
                              ),
                              subtitle: Text(
                                'Te odio Gabriel Garcia por crear este figma',
                                style: theme.textTheme.bodyLarge, // Descripción con bodyLarge
                              ),
                            ),
                            ListTile(
                              leading: Icon(Icons.question_answer, color: colors.inversePrimary),
                              title: Text(
                                'Respuesta 2',
                                style: theme.textTheme.displayMedium, // Título con displayMedium
                              ),
                              subtitle: Text(
                                'Descripción de la respuesta 2',
                                style: theme.textTheme.bodyLarge, // Descripción con bodyLarge
                              ),
                            ),
                            // Agrega más respuestas aquí
                          ],
                        ),

                        // Contenido de "Objetos"
                        ListView(
                          children: [
                            ListTile(
                              leading: Icon(Icons.category, color: colors.inversePrimary),
                              title: Text(
                                'Objeto 1',
                                style: theme.textTheme.displayMedium, // Título con displayMedium
                              ),
                              subtitle: Text(
                                'Descripción del objeto 1',
                                style: theme.textTheme.bodyLarge, // Descripción con bodyLarge
                              ),
                            ),
                            ListTile(
                              leading: Icon(Icons.category, color: colors.inversePrimary),
                              title: Text(
                                'Objeto 2',
                                style: theme.textTheme.displayMedium, // Título con displayMedium
                              ),
                              subtitle: Text(
                                'Descripción del objeto 2',
                                style: theme.textTheme.bodyLarge, // Descripción con bodyLarge
                              ),
                            ),
                            // Agrega más objetos aquí
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
void _editarPerfil() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(
          currentName: _nombre,
          currentLastName: _apellido,
          currentDescription: _descripcion,
          currentUsername: _usuario,
          onSave: (nuevoNombre, nuevoApellido, nuevaDescripcion) {
            setState(() {
              _nombre = nuevoNombre;
              _apellido = nuevoApellido;
              _descripcion = nuevaDescripcion;
            });
          },
        ),
      ),
    );
  }
  // Función para mostrar el popup de amigos
 void _mostrarPopupAmigos(BuildContext context, List<String> amigos) {
    final colors = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Amigos', style: Theme.of(context).textTheme.displayMedium),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: amigos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(amigos[index]),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: colors.secondary, // Color del texto
              ),
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }


  // Función para mostrar el popup de sincronizados
 void _mostrarPopupSincronizados(BuildContext context, List<String> sincronizados) {
    final colors = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Sincronizados', style: Theme.of(context).textTheme.displayMedium),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: sincronizados.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(sincronizados[index]),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: colors.secondary, // Color del texto
              ),
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}