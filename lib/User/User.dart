import '../MongoManager/MongoDB.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:bcrypt/bcrypt.dart';
import "Current.dart";




class User {
  final MongoDB _db = MongoDB();
  late String _username;
  String? _email;
  String? _name;
  String? _lastname;
  String? _descripcion_perfil;
  List<Map<String, String>> _friends = [];
  List<Map<String, dynamic>> _friendRequests = []; // Declaración de friendRequests

  User();

  // Métodos existentes
  String? getdescription() {
    return _descripcion_perfil;
  }

  Future<void> addFriend(String friendUsername, String friendName) async {
    if (!_friends.any((friend) => friend['username'] == friendUsername)) {
      _friends.add({'username': friendUsername, 'name': friendName});
      await _updateFriendsInDB();
    }
  }

  Future<void> loadFriends() async {
    try {
      await MongoDB.connect();
      var userData = await _db.findOneFrom('Users', where.eq('username', _username));

      if (userData != null && userData['friends'] != null) {
        _friends = (userData['friends'] as List).map((friend) {
          return {
            'username': friend['username']?.toString() ?? '',
            'name': friend['name']?.toString() ?? '',
          };
        }).toList();
      } else {
        _friends = [];
      }
    } catch (e) {
      print('Error cargando amigos: $e');
    } finally {
      await MongoDB.close();
    }
  }

  Future<void> _updateFriendsInDB() async {
    try {
      await MongoDB.connect();
      await _db.updateOneFrom(
        'Users',
        where.eq('username', _username),
        modify.set('friends', _friends),
      );
    } catch (e) {
      print('Error actualizando amigos: $e');
      throw e;
    } finally {
      await MongoDB.close();
    }
  }

  List<Map<String, String>> getFriends() {
    return _friends;
  }

  Future<bool> loginUser(String username, String password) async {
    try {
      await MongoDB.connect();
      var usuarioExistente = await _db.findOneFrom('Users', where.eq('username', username));

      if (usuarioExistente == null) return false;

      final hashedPassword = usuarioExistente['password'] as String;
      final isValid = BCrypt.checkpw(password, hashedPassword);

      if (isValid) {
        _username = usuarioExistente['username'] as String;
        _name = usuarioExistente['name'] as String;
        _lastname = usuarioExistente['lastname'] as String;
        _email = usuarioExistente['email'] as String;
        _descripcion_perfil = usuarioExistente['description'] as String? ?? '';
        _friendRequests = (usuarioExistente['friendRequests'] as List?)?.cast<Map<String, dynamic>>() ?? []; // Cargar friendRequests
        Current().setUser(this);
      }

      return isValid;
    } catch (e) {
      print('Error en login: $e');
      return false;
    } finally {
      await MongoDB.close();
    }
  }

  Future<bool> registerUser(String username, String password, String email, String name, String lastname) async {
    try {
      await MongoDB.connect();
      var usuarioExistente = await _db.findOneFrom('Users', where.eq('username', username));
      var correoExistente = await _db.findOneFrom('Users', where.eq('email', email));

      if (usuarioExistente != null) {
        print('Error: El nombre de usuario ya existe.');
        return false;
      }
      if (correoExistente != null) {
        print('Error: El correo ya está registrado.');
        return false;
      }

      _descripcion_perfil = '';
      String hash = BCrypt.hashpw(password, BCrypt.gensalt());
      _email = email;
      _name = name;
      _lastname = lastname;
      _username = username;

      var nuevoUsuario = {
        '_id': username,
        'username': _username,
        'password': hash,
        'name': _name,
        'lastname': _lastname,
        'email': _email,
        'description': _descripcion_perfil,
        'friends': [],
        'friendRequests': [], // Inicializar lista de solicitudes de amistad
      };

      await _db.insertInto('Users', nuevoUsuario);
      Current().setUser(this);
      return true;
    } catch (e) {
      print('Error en registro: $e');
      return false;
    } finally {
      await MongoDB.close();
    }
  }

  Future<void> updateProfile(String newName, String newLastname, String newDescription) async {
    try {
      await MongoDB.connect();
      await _db.updateOneFrom(
        'Users',
        where.eq('username', _username),
        modify
          .set('name', newName)
          .set('lastname', newLastname)
          .set('description', newDescription),
      );

      _name = newName;
      _lastname = newLastname;
      _descripcion_perfil = newDescription;

      Current().setUser(this);
    } catch (e) {
      print('Error actualizando perfil: $e');
      throw e;
    } finally {
      await MongoDB.close();
    }
  }

  String getusername() {
    return _username;
  }

  String? getemail() {
    return _email;
  }

  String? getname() {
    return _name;
  }

  String? getlastname() {
    return _lastname;
  }

  // Métodos para manejar solicitudes de amistad
  Future<void> sendFriendRequest(String toUsername, String User) async {
    try {
      await MongoDB.connect();
      await _db.updateOneFrom(
        'Users',
        where.eq('username', toUsername),
        modify.push('friendRequests', {
          'from': _username,
          'status': 'pending',
           "to":toUsername
        }),
      );
      await _db.updateOneFrom(
        'Users',
        where.eq('username', User),
        modify.push('friendRequests', {
          'from': _username,
          'status': 'pending',
           "to":toUsername
        }),
      );
    } catch (e) {
      print('Error enviando solicitud de amistad: $e');
      throw e;
    } finally {
      await MongoDB.close();
    }
  }

  Future<void> acceptFriendRequest(String fromUsername) async {
    try {
      await MongoDB.connect();
      // Eliminar la solicitud pendiente
      await _db.updateOneFrom(
        'Users',
        where.eq('username', _username),
        modify.pull('friendRequests', {
          'from': fromUsername,
          'status': 'pending',
        }),
      );

      // Agregar como amigo
      await addFriend(fromUsername, fromUsername);

      // Notificar al otro usuario que la solicitud fue aceptada
      await _db.updateOneFrom(
        'Users',
        where.eq('username', fromUsername),
        modify.push('friends', {
          'username': _username,
          'name': _name ?? '',
        }),
      );
    } catch (e) {
      print('Error aceptando solicitud de amistad: $e');
      throw e;
    } finally {
      await MongoDB.close();
    }
  }

  Future<void> rejectFriendRequest(String fromUsername) async {
    try {
      await MongoDB.connect();
      // Eliminar la solicitud pendiente
      await _db.updateOneFrom(
        'Users',
        where.eq('username', _username),
        modify.pull('friendRequests', {
          'from': fromUsername,
          'status': 'pending',
        }),
      );
    } catch (e) {
      print('Error rechazando solicitud de amistad: $e');
      throw e;
    } finally {
      await MongoDB.close();
    }
  }

Future<List<Map<String, dynamic>>> getPendingFriendRequests() async {
  try {
    await MongoDB.connect();
    var userData = await _db.findOneFrom('Users', where.eq('username', _username));
    if (userData != null && userData['friendRequests'] != null) {
      // Convertir la lista a List<Map<String, dynamic>>
      List<Map<String, dynamic>> friendRequests = (userData['friendRequests'] as List)
          .cast<Map<String, dynamic>>() // Convertir a List<Map<String, dynamic>>
          .where((request) => request['status'] == 'pending') // Filtrar solicitudes pendientes
          .toList();
      return friendRequests;
    }
    return [];
  } catch (e) {
    print('Error obteniendo solicitudes de amistad: $e');
    throw e;
  } finally {
    await MongoDB.close();
  }
}
}