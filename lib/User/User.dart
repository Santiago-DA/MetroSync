

import '../Schedules/Schedule.dart';
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

  //Me volvi un 8 okey? no me juzguen
  User();

  // Schedule getmyschedule(){
  //   return(_myschedule);
  // }
  String? getdescription() {
    return _descripcion_perfil;
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

  void _changename(String newname){
    _name=newname;
  }

  void _changelastname(String newlastname){
    _lastname=newlastname;
  }

  void _changeemail(String newemail){
    _email=newemail;
  }

  void _changeusername(String newusername){
    _username=newusername;
  }

  void _dbnameupdate(){
    //Actualiza el nombre
  }

  void _dbemailupdate(){
    //Actualiza el email
  }

}
