import 'package:flutter/material.dart';
import 'package:metrosync/GUI/Pages/SettingsScreen.dart';
import 'package:metrosync/User/Current.dart';
import "EditProfilePage.dart";
import 'package:metrosync/MongoManager/MongoDB.dart';
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String _nombre;
  late String _apellido;
  late String _usuario;
  late String _descripcion;
  bool _isExpanded = false;
  List<Map<String, String>> _usuarios=[];
  @override
  void initState() {
    super.initState();
    _initializeUser();
  }
 void _initializeUser() async {
     _cargarDatosUsuario();
    await _loadFriends(); 
   // Esperar a que los amigos se carguen
   // Esperar a que el horario se cargue
}

    Future<void> _loadFriends() async {
  final currentUser = Current().currentUser;
  if (currentUser != null) {
    
    try {
      // Conectar a la base de datos
      await MongoDB.connect();
  
      // Cargar amigos desde la base de datos
      await currentUser.loadFriends();

      // Actualizar el estado con los amigos cargados
      setState(() {
        _usuarios = currentUser.getFriends();
        print('Amigos cargados: $_usuarios');
      });
    } catch (e) {
      print('Error cargando amigos: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error cargando amigos: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      // Cerrar la conexión a la base de datos
      await MongoDB.close();
      ;
    }
  } else {
    print('Usuario no logueado, no se pueden cargar amigos.');
  }
}

  void _cargarDatosUsuario() {
    final user = Current().currentUser;
    setState(() {
      _nombre = user?.getname() ?? '';
      _apellido = user?.getlastname() ?? '';
      _usuario = user?.getusername() ?? '';
      _descripcion = user?.getdescription() ?? '';
      
    });
  }

 

 



  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    
    
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Perfil', style: theme.textTheme.labelLarge),
        centerTitle: true,
        backgroundColor: colors.primary,
        foregroundColor: colors.inversePrimary,
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.white),
            onPressed: _editarPerfil,
          ),
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.account_circle,
                    size: 60,
                    color: colors.inversePrimary,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
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
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isExpanded = !_isExpanded; // Alternar estado
                            });
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _descripcion,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: colors.inversePrimary.withOpacity(0.7),
                                ),
                                maxLines: _isExpanded ? null : 1, // Mostrar 3 líneas si no está expandido
                                overflow: _isExpanded
                                    ? TextOverflow.visible
                                    : TextOverflow.ellipsis, // Mostrar "..." si no está expandido
                              ),
                              if (_descripcion.length > 100) // Mostrar botón solo si el texto es largo
                                Text(
                                  _isExpanded ? 'Ver menos' : 'Ver más',
                                  style: TextStyle(
                                    color: colors.secondary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                
                                final user = Current().currentUser;
                                if (user != null) {
                                  _mostrarPopupAmigos(context);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('No se pudo cargar la lista de amigos.'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colors.secondary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Text(
                                'Amigos',
                                style: theme.textTheme.labelSmall?.copyWith(),
                              ),
                            ),
                            const SizedBox(width: 10),
                            
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
      
        
      
    
  


            // Pestañas de "Publicaciones", "Respuestas" y "Objetos"
            //     DefaultTabController(
            //       length: 3, // Número de pestañas
            //       child: Column(
            //         children: [
            //           // Barra de pestañas
            //           TabBar(
            //             labelColor: colors.inversePrimary,
            //             unselectedLabelColor: colors.inversePrimary.withOpacity(0.5),
            //             indicatorColor: colors.inversePrimary,
            //             labelStyle: theme.textTheme.displayLarge?.copyWith(
            //               fontSize: 16, // Reducir el tamaño de fuente
            //             ),
            //             unselectedLabelStyle: theme.textTheme.displayLarge?.copyWith(
            //               fontSize: 14, // Reducir el tamaño de fuente
            //             ),
            //             tabs: const [
            //               Tab(text: 'Publicaciones'),
            //               Tab(text: 'Respuestas'),
            //               Tab(text: 'Objetos'),
            //             ],
            //           ),
            //           const SizedBox(height: 20),

            //           // Contenido de las pestañas
            //           SizedBox(
            //             height: 400, // Altura fija para el contenido de las pestañas
            //             child: TabBarView(
            //               children: [
            //                 // Contenido de "Publicaciones"
            //                 ListView(
            //                   children: [
            //                     ListTile(
            //                       leading: Icon(Icons.post_add, color: colors.inversePrimary),
            //                       title: Text(
            //                         'Publicación 1',
            //                         style: theme.textTheme.displayMedium, // Título con displayMedium
            //                       ),
            //                       subtitle: Text(
            //                         'Descripción de la publicación 1',
            //                         style: theme.textTheme.bodyLarge, // Descripción con bodyLarge
            //                       ),
            //                     ),
            //                     ListTile(
            //                       leading: Icon(Icons.post_add, color: colors.inversePrimary),
            //                       title: Text(
            //                         'Publicación 2',
            //                         style: theme.textTheme.displayMedium, // Título con displayMedium
            //                       ),
            //                       subtitle: Text(
            //                         'Descripción de la publicación 2',
            //                         style: theme.textTheme.bodyLarge, // Descripción con bodyLarge
            //                       ),
            //                     ),
            //                     // Agrega más publicaciones aquí
            //                   ],
            //                 ),

            //                 // Contenido de "Respuestas"
            //                 ListView(
            //                   children: [
            //                     ListTile(
            //                       leading: Icon(Icons.question_answer, color: colors.inversePrimary),
            //                       title: Text(
            //                         'Creacion de Figma',
            //                         style: theme.textTheme.displayMedium, // Título con displayMedium
            //                       ),
            //                       subtitle: Text(
            //                         'Te odio Gabriel Garcia por crear este figma',
            //                         style: theme.textTheme.bodyLarge, // Descripción con bodyLarge
            //                       ),
            //                     ),
            //                     ListTile(
            //                       leading: Icon(Icons.question_answer, color: colors.inversePrimary),
            //                       title: Text(
            //                         'Respuesta 2',
            //                         style: theme.textTheme.displayMedium, // Título con displayMedium
            //                       ),
            //                       subtitle: Text(
            //                         'Descripción de la respuesta 2',
            //                         style: theme.textTheme.bodyLarge, // Descripción con bodyLarge
            //                       ),
            //                     ),
            //                     // Agrega más respuestas aquí
            //                   ],
            //                 ),

            //                 // Contenido de "Objetos"
            //                 ListView(
            //                   children: [
            //                     ListTile(
            //                       leading: Icon(Icons.category, color: colors.inversePrimary),
            //                       title: Text(
            //                         'Objeto 1',
            //                         style: theme.textTheme.displayMedium, // Título con displayMedium
            //                       ),
            //                       subtitle: Text(
            //                         'Descripción del objeto 1',
            //                         style: theme.textTheme.bodyLarge, // Descripción con bodyLarge
            //                       ),
            //                     ),
            //                     ListTile(
            //                       leading: Icon(Icons.category, color: colors.inversePrimary),
            //                       title: Text(
            //                         'Objeto 2',
            //                         style: theme.textTheme.displayMedium, // Título con displayMedium
            //                       ),
            //                       subtitle: Text(
            //                         'Descripción del objeto 2',
            //                         style: theme.textTheme.bodyLarge, // Descripción con bodyLarge
            //                       ),
            //                     ),
            //                     // Agrega más objetos aquí
            //                   ],
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
          ],
        ),
      ),
    );
  }

  void _editarPerfil() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(
          currentName: _nombre,
          currentLastName: _apellido,
          currentDescription: _descripcion,
          currentUsername: _usuario,
          onSave: (nuevoNombre, nuevoApellido, nuevaDescripcion) async {
            final user = Current().currentUser;
            if (user != null) {
              await user.updateProfile(
                  nuevoNombre, nuevoApellido, nuevaDescripcion);
              _cargarDatosUsuario();
            }
          },
        ),
      ),
    );
  }
void _mostrarPopupAmigos(BuildContext context) {
  final colors = Theme.of(context).colorScheme;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Amigos', style: Theme.of(context).textTheme.displayMedium),
        content: FutureBuilder<void>(
          future: _loadFriends(), // Cargar amigos
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Muestra un indicador de carga mientras se cargan los amigos
              return Center(
                child: CircularProgressIndicator(
                  color: colors.inversePrimary,
                ),
              );
            } else if (snapshot.hasError) {
              // Muestra un mensaje de error si la carga falla
              return Center(
                child: Text(
                  'Error cargando amigos: ${snapshot.error}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: colors.inversePrimary.withOpacity(0.7),
                      ),
                ),
              );
            } else {
              // Muestra la lista de amigos una vez que se han cargado
              return SizedBox(
                width: double.maxFinite,
                child: _usuarios.isEmpty
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 48,
                            color: colors.inversePrimary.withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No hay amigos, pero descuida, ya los encontrarás.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: colors.inversePrimary.withOpacity(0.7),
                                ),
                          ),
                        ],
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: _usuarios.length,
                        itemBuilder: (context, index) {
                          final amigo = _usuarios[index];
                          return ListTile(
                            leading: Icon(Icons.account_circle,
                                color: colors.inversePrimary),
                            title: Text(amigo['username'] ?? 'Usuario desconocido'),
                            subtitle: Text(amigo['name'] ?? 'Nombre no disponible'),
                          );
                        },
                      ),
              );
            }
          },
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
}}