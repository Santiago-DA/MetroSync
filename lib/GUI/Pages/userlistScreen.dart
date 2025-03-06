import 'package:flutter/material.dart';

class Userlist extends StatefulWidget {
  const Userlist({super.key});

  @override
  State<Userlist> createState() => _UserlistState();
}

class _UserlistState extends State<Userlist> {
  final List<String> _userNames = List.generate(10, (index) => 'Usuario ${index + 1}');
  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredUsers = [];

  @override
  void initState() {
    super.initState();
    _filteredUsers = _userNames; // Inicialmente, muestra todos los usuarios
    _searchController.addListener(_filterUsers);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterUsers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredUsers = _userNames
          .where((user) => user.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Usuarios',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar usuario...',
                prefixIcon: Icon(Icons.search, size: 20), // Icono más pequeño
                contentPadding: EdgeInsets.symmetric(vertical: 8.0), // Barra más delgada
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: _filteredUsers.length,
              separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey[300]), // Separador entre usuarios
              itemBuilder: (context, index) {
                return UserListItem(
                  userName: _filteredUsers[index],
                  userImageUrl: 'https://via.placeholder.com/150', // URL de la imagen de perfil
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class UserListItem extends StatelessWidget {
  final String userName;
  final String userImageUrl;

  const UserListItem({
    super.key,
    required this.userName,
    required this.userImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(userImageUrl),
      ),
      title: Text(userName),
      trailing: ElevatedButton(
        onPressed: () {
          // Acción al presionar el botón de seguir
          print('Seguir a $userName');
        },
        child: Text('Seguir'),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:metrosync/MongoManager/MongoDB.dart'; // Importar MongoDB







// class Userlist extends StatefulWidget {
//   const Userlist({super.key});

//   @override
//   State<Userlist> createState() => _UserlistState();
// }

// class _UserlistState extends State<Userlist> {
//   List<Map<String, dynamic>> users = []; // Lista para almacenar los usuarios

//   @override
//   void initState() {
//     super.initState();
//     _loadUsers(); // Cargar la lista de usuarios al iniciar la pantalla
//   }

//   // Método para cargar los usuarios desde la base de datos
//   Future<void> _loadUsers() async {
//     try {
//       await MongoDB.connect(); // Conectar a la base de datos
//       var userCollection = MongoDB.db.collection('Users'); // Obtener la colección de usuarios
//       var userList = await userCollection.find().toList(); // Obtener todos los usuarios

//       setState(() {
//         users = userList; // Actualizar la lista de usuarios
//       });
//     } catch (e) {
//       print('Error cargando usuarios: $e');
//     } finally {
//       await MongoDB.close(); // Cerrar la conexión a la base de datos
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Lista de Usuarios'),
//         centerTitle: true,
//       ),
//       body: ListView.builder(
//         itemCount: users.length,
//         itemBuilder: (context, index) {
//           final user = users[index];
//           return ListTile(
//             title: Text(user['username'] ?? 'Sin nombre'), // Mostrar el nombre de usuario
//             subtitle: Text(user['email'] ?? 'Sin correo'), // Mostrar el correo del usuario
//             onTap: () {
//               // Acción al hacer clic en un usuario
//               print('Usuario seleccionado: ${user['username']}');
//             },
//           );
//         },
//       ),
//     );
//   }
// }