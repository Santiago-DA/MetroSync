

import '../Schedules/Schedule.dart';
import '../MongoManager/MongoDB.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:bcrypt/bcrypt.dart';
class User {
  //Agregar descripcion de perfil
  final MongoDB _db = MongoDB();
  late Schedule _myschedule;
  late String _username;
  String? _email;
  String? _name;
  String? _lastname;  
  String? _descripcion_perfil;

  //Me volvi un 8 okey? no me juzguen
  User();

  Schedule getmyschedule(){
    return(_myschedule);
  }

 Future<bool> loginUser(String username, String password) async {
  try {
    await _db.connect();
    var usuarioExistente = await _db.findOneFrom('usuarios', where.eq('username', username));
    
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
      _descripcion_perfil = usuarioExistente['description'] as String;
      
      // Cargar horario si existe
      if (usuarioExistente.containsKey('schedule')) {
        // _myschedule = Schedule.fromMap(usuarioExistente['schedule']);
      }
    }
    
    return isValid;
  } catch (e) {
    print('Error en login: $e');
    return false;
  } finally {
    await _db.close();
  }
}

  //Agregar el correo y todo lo demás
  Future<bool> registerUser(String username, String password,String email, String name, String lastname) async {
    //guardar el user en la BD
    //Revisar si ya existe un registro
    // Conectarse a la base de datos
    await _db.connect();
    // Verificar si el nombre de usuario ya existe
    var usuarioExistente =
        await _db.findOneFrom('usuarios', where.eq('username', username));
    if (usuarioExistente != null) {
      // Si el nombre de usuario ya existe, lanzar una alerta
      print('Error: El nombre de usuario ya existe.');
      return(false);
    } else {
      String hash = BCrypt.hashpw(password, BCrypt.gensalt());
      _email=email;
      _name=name;
      _lastname=lastname;
      _username=username;
      // Si el nombre de usuario no existe, guardar los datos del nuevo usuario
      var nuevoUsuario = {
        'username': _username,
        'password':
            hash, // hashear la contraseña antes de guardarla
        'name': _name,
        'lastname': _lastname,
        'email': _email,
        'schedule': _myschedule,
        'description':_descripcion_perfil
      };
      await _db.insertInto('usuarios', nuevoUsuario);
      await _db.close();
      return(true);
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
