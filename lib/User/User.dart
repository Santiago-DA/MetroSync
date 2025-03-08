import '../MongoManager/MongoDB.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:bcrypt/bcrypt.dart';
import "Current.dart";
class User {
  //Agregar descripcion de perfil
  final MongoDB _db = MongoDB();
  // late Schedule _myschedule;
  late String _username;
  String? _email;
  String? _name;
  String? _lastname;  
  String? _descripcion_perfil;
  List<String> _friends = [];
  //Me volvi un 8 okey? no me juzguen
  User();

  // Schedule getmyschedule(){
  //   return(_myschedule);
  // }
  String? getdescription() {
    return _descripcion_perfil;
  }
  List<String> getFriends() {
    return _friends;
  }

  // Añadir un amigo
  Future<void> addFriend(String friendUsername) async {
    if (!_friends.contains(friendUsername)) {
      _friends.add(friendUsername);
      await _updateFriendsInDB();
    }
  }

  // Eliminar un amigo
  Future<void> removeFriend(String friendUsername) async {
    _friends.remove(friendUsername);
    await _updateFriendsInDB();
  }

  // Actualizar la lista de amigos en la base de datos
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

  // Cargar la lista de amigos desde la base de datos
Future<void> loadFriends() async {
  try {
    // Ensure the database connection is open
    if (MongoDB.db == null || MongoDB.db.state != State.OPEN) {
      await MongoDB.connect();
      print('Conexión a MongoDB establecida.');
    }

    // Buscar el usuario en la base de datos
    var userData = await MongoDB.userCollection.findOne(where.eq('username', _username));
    print('Datos del usuario: $userData');

    if (userData != null) {
      // Verificar si el campo 'friends' existe y no es nulo
      if (userData['friends'] != null) {
        // Convertir la lista de amigos a List<String>
        _friends = List<String>.from(userData['friends']);
        print('Amigos cargados: $_friends');
      } else {
        // Si 'friends' es nulo, inicializar como lista vacía
        _friends = [];
        print('El campo "friends" es nulo. Inicializando como lista vacía.');
      }
    } else {
      // Si no se encuentra el usuario, lanzar una excepción
      throw Exception('Usuario no encontrado en la base de datos.');
    }
  } catch (e) {
    // Manejar errores
    print('Error cargando amigos: $e');
    throw e;
  }
}

 Future<bool> loginUser(String username, String password) async {
  try {
    await MongoDB.connect();
    var usuarioExistente = await _db.findOneFrom('Users', where.eq('username', username));
    
    if (usuarioExistente == null) return false;
    
    // Obtener la contraseña hasheada de la base de datos
    final hashedPassword = usuarioExistente['password'] as String;
    
    // Verificar contraseña con BCrypt
    final isValid = BCrypt.checkpw(password, hashedPassword);
    
    if (isValid) {
      // Cargar datos del usuario
      _username = usuarioExistente['username'] as String;
      _name = usuarioExistente['name'] as String;
      _lastname = usuarioExistente['lastname'] as String;
      _email = usuarioExistente['email'] as String;
      _descripcion_perfil = usuarioExistente['description'] as String? ?? '';
      
      // Actualizar instancia global
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

  //Agregar el correo y todo lo demás
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
      print('Error: El correo ya esta registrado.');
      return false;
    }
    _descripcion_perfil = '';
    String hash = BCrypt.hashpw(password, BCrypt.gensalt());
    _email = email;
    _name = name;
    _lastname = lastname;
    _username = username;

    // Generar un _id único como String
    var nuevoUsuario = {
      '_id': username, // Usar username como _id (o generar un UUID)
      'username': _username,
      'password': hash,
      'name': _name,
      'lastname': _lastname,
      'email': _email,
      'description': _descripcion_perfil,
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
        .set('description', newDescription)
    );
    
    _name = newName;
    _lastname = newLastname;
    _descripcion_perfil = newDescription;
    
    // Actualizar instancia global
    Current().setUser(this);
    
  } catch (e) {
    print('Error actualizando perfil: $e');
    throw e;
  } finally {
    await MongoDB.close();
  }
}

  String getusername(){
    return(_username);
  }

  String? getemail(){
    return(_email);
  }

  String? getname(){
    return(_name);
  }

  String? getlastname(){
    return(_lastname);
  }


}
