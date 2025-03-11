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
  List<Map<String, String>> _allUsers = [];
  List<Map<String, String>> _filteredUsers = [];
  final MongoDB _db = MongoDB();
  bool _isLoading = true;
  bool _hasError = false;
  int _currentPage = 0;
  final int _usersPerPage = 10;
  final Set<String> _followedUsers = {};
  final Set<String> _sentRequests = {}; // Solicitudes enviadas
  final Set<String> _receivedRequests = {}; // Solicitudes recibidas

  @override
  void initState() {
    super.initState();
    _loadAllUsers();
    _searchController.addListener(_filterUsers);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

    Future<void> _loadAllUsers() async {
      try {
        await MongoDB.connect();
        var users = await _db.findManyFrom('Users', null);
        final currentUser = Current().currentUser;

        if (currentUser != null) {
          await currentUser.loadFriends();
          _followedUsers.addAll(currentUser.getFriends().map((friend) => friend['username']!));

          // Cargar solicitudes de amistad
          var pendingRequests = await currentUser.getPendingFriendRequests();
          print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
          print(pendingRequests);
          for (var request in pendingRequests) {
            if (request['to'] == currentUser.getusername()) {
              _receivedRequests.add(request['from'] as String); 
              // Solicitudes recibidas
            } else if (request['from'] == currentUser.getusername()) {
              _sentRequests.add(request['to'] as String); // Solicitudes enviadas
            }
          }
        }

        setState(() {
          _allUsers = users
              .map((user) => {
                    'username': user['username'] as String,
                    'name': user['name'] as String,
                    "lastname": user["lastname"] as String,
                  })
              .where((user) =>
                  user['username'] != currentUser?.getusername()) // Excluir al usuario actual
              .toList();
          _filteredUsers = _allUsers.take(_usersPerPage).toList();
          _isLoading = false;
        });
      } catch (e) {
        print('Error cargando usuarios: $e');
        setState(() {
          _hasError = true;
          _isLoading = false;
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

  // Enviar una solicitud de amistad
  Future<void> _sendFriendRequest(String friendUsername) async {
  final currentUser = Current().currentUser;
  if (currentUser != null) {
    await currentUser.sendFriendRequest(friendUsername);
    setState(() {
      _sentRequests.add(friendUsername); // Agregar a la lista de solicitudes enviadas
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Solicitud de amistad enviada a $friendUsername'),
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
          style: Theme.of(context).textTheme.titleSmall,
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
                                final userFullName = '${user['name'] ?? ''} ${user['lastname'] ?? ''}'.trim();
                                final isFriend = _followedUsers.contains(userName);
                                final isSentRequest = _sentRequests.contains(userName); // Solicitud enviada
                                final isReceivedRequest = _receivedRequests.contains(userName); // Solicitud recibida

                                return UserListItem(
                                  userName: userName,
                                  userFullName: userFullName,
                                  userImageUrl: 'https://via.placeholder.com/150',
                                  isFollowed: isFriend,
                                  isSentRequest: isSentRequest,
                                  isReceivedRequest: isReceivedRequest,
                                  onFollow: () => _sendFriendRequest(userName),
                                );
                              } else {
                                return Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Center(
                                    child: ElevatedButton(
                                      style: Theme.of(context).elevatedButtonTheme.style,
                                      onPressed: _loadMoreUsers,
                                      child: Text(
                                        'Cargar más',
                                        style: Theme.of(context).textTheme.labelMedium,
                                      ),
                                    ),
                                  ),
                                );
                              }
                            }
                          ),
          ),
        ],
      ),
    );
  }
}

class UserListItem extends StatelessWidget {
  final String userName;
  final String userFullName;
  final String userImageUrl;
  final bool isFollowed;
  final bool isSentRequest; // Solicitud enviada
  final bool isReceivedRequest; // Solicitud recibida
  final VoidCallback onFollow;

  const UserListItem({
    super.key,
    required this.userName,
    required this.userFullName,
    required this.userImageUrl,
    required this.isFollowed,
    required this.isSentRequest,
    required this.isReceivedRequest,
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
      subtitle: Text(userFullName),
      trailing: isFollowed
          ? Text(
              'Seguido',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.secondary,
              ),
            )
          : isReceivedRequest
              ? Text(
                  'Solicitud recibida',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.secondary,
                  ),
                )
              : isSentRequest
                  ? Text(
                      'Solicitud enviada',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.secondary,
                      ),
                    )
                  : ElevatedButton(
                      onPressed: onFollow,
                      child: Text(
                        'Enviar solicitud',
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