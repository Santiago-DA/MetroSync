import 'package:flutter/material.dart';
import 'package:metrosync/MongoManager/MongoDb.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:metrosync/User/Current.dart';

class Userlist extends StatefulWidget {
  const Userlist({super.key});

  @override
  State<Userlist> createState() => _UserlistState();
}

class _UserlistState extends State<Userlist> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _allUsers = []; // Todos los usuarios de la base de datos
  List<Map<String, String>> _filteredUsers = []; // Usuarios filtrados
  final MongoDB _db = MongoDB();
  bool _isLoading = true; // Estado de carga
  bool _hasError = false; // Estado de error

  // Variables para la paginación
  int _currentPage = 0; // Página actual
  final int _usersPerPage = 10; // Usuarios por página

  // Set para rastrear usuarios seguidos
  final Set<String> _followedUsers = {};

  @override
  void initState() {
    super.initState();
    _loadAllUsers(); // Cargar todos los usuarios al iniciar
    _searchController.addListener(_filterUsers);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Cargar todos los usuarios de la base de datos
  Future<void> _loadAllUsers() async {
    try {
      await MongoDB.connect();
      var users = await _db.findManyFrom('Users', null);
      final currentUser = Current().currentUser;

      setState(() {
        _allUsers = users
            .map((user) => {
                  'username': user['username'] as String,
                  'name': user['name'] as String,
                })
            .where((user) =>
                user['username'] != currentUser?.getusername()) // Excluir al usuario actual
            .toList();
        _filteredUsers = _allUsers.take(_usersPerPage).toList(); // Mostrar solo los primeros 10
        _isLoading = false; // Finalizar la carga
      });
    } catch (e) {
      print('Error cargando usuarios: $e');
      setState(() {
        _hasError = true; // Indicar que ocurrió un error
        _isLoading = false; // Finalizar la carga
      });
    } finally {
      await MongoDB.close();
    }
  }

  // Filtrar usuarios según la búsqueda
  void _filterUsers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredUsers = _allUsers
          .where((user) => user['username']!.toLowerCase().contains(query))
          .take(_usersPerPage) // Limitar a 10 usuarios en la búsqueda
          .toList();
    });
  }

  // Cargar más usuarios
  void _loadMoreUsers() {
    setState(() {
      _currentPage++; // Incrementar la página
      _filteredUsers = _allUsers
          .take((_currentPage + 1) * _usersPerPage) // Cargar los siguientes 10
          .toList();
    });
  }

  // Añadir un amigo
  Future<void> _addFriend(String friendUsername, String friendName) async {
    final currentUser = Current().currentUser;
    if (currentUser != null) {
      await currentUser.addFriend(friendUsername, friendName);
      setState(() {
        _followedUsers.add(friendUsername); // Agregar al conjunto de usuarios seguidos
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ahora sigues a $friendUsername'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Usuarios',
          style: Theme.of(context).textTheme.titleMedium,
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
                prefixIcon: Icon(Icons.search, size: 20),
                contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator()) // Indicador de carga
                : _hasError
                    ? Center(child: Text('Error al cargar los usuarios')) // Mensaje de error
                    : _filteredUsers.isEmpty
                        ? Center(child: Text('No se encontraron usuarios')) // Lista vacía
                        : ListView.separated(
                            itemCount: _filteredUsers.length + 1, // +1 para el botón "Cargar más"
                            separatorBuilder: (context, index) => Divider(
                                  height: 4,
                                  color: Theme.of(context).colorScheme.surface,
                                ),
                            itemBuilder: (context, index) {
                                if (index < _filteredUsers.length) {
                                  final user = _filteredUsers[index];
                                  final userName = user['username']!;
                                  final userFullName = user['name']!;
                                  return UserListItem(
                                    userName: userName,
                                    userImageUrl: 'https://via.placeholder.com/150',
                                    isFollowed: _followedUsers.contains(userName), // Verificar si ya está seguido
                                    onFollow: () => _addFriend(userName, userFullName), // Acción al seguir
                                  );
                                } else {
                                  return Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Center(
                                      child: ElevatedButton(
                                        onPressed: _loadMoreUsers, // Cargar más usuarios
                                        child: Text('Cargar más',
                                        style: Theme.of(context).textTheme.labelMedium,
                                        ),
                                      ),
                                    ),
                                  );
                                }
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
  final bool isFollowed; // Indica si el usuario ya está seguido
  final VoidCallback onFollow;

  const UserListItem({
    super.key,
    required this.userName,
    required this.userImageUrl,
    required this.isFollowed,
    required this.onFollow,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(userImageUrl),
      ),
      title: Text(userName),
      trailing: isFollowed
          ? Text(
              'Seguido',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.secondary,
              ),
            )
          : ElevatedButton(
              onPressed: onFollow, // Acción al presionar el botón de seguir
              child: Text(
                'Seguir',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.surface,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.secondary,
              ),
            ),
    );
  }
}