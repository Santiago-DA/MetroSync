//import 'dart:ffi';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:metrosync/MongoManager/MongoDb.dart';
import '../User/User.dart';
import '../lost_item/lost_item.dart';

class VM extends ChangeNotifier {
  User _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  List<LostItem> lostitem = [];

  VM() : _currentUser = User();

  // Getters para acceder al estado desde la UI
  User get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> logIn(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _currentUser.loginUser(username, password);
      _isLoading = false;
      notifyListeners();

      return success;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error en el login: ${e.toString()}';
      notifyListeners();

      return false;
    }
  }

  Future<bool> register(
      String password, String email, String name, String lastname) async {
    _isLoading = true;
    notifyListeners();
    _errorMessage = null;

    try {
      final success =
          await _currentUser.registerUser(password, email, name, lastname);

      if (success) {
        _errorMessage = null;
        _isLoading = false;
        notifyListeners();
        return success;
      } else {
        _errorMessage = 'Credenciales inválidas';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error en el login: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void logOut() {
    _currentUser = User();
    notifyListeners();
  }
  //Cargar 10 Items de BD

  //Crear Item
  Future<bool> crearItem(String title, String tag, String imageURL) async {
    //Asignar color de cada tag
    //Craer id global unico
    var uuid = Uuid();
    String id = uuid.v4();
    //Crear objeto en local
    //No se como guardar el color en la BD
    LostItem newitem = LostItem(
        id: id,
        title: title,
        tag: tag,
        tagColor: 'color',
        imageUrl: 'imageUrl');
    //Mandar solicitud para subir a la BD
    try {
      await MongoDB.connect();
      bool v = await newitem.guardarBD();
      if (v) {
        //Si es exitoso, guardar objeto en local
        print('entro');
        lostitem.add(newitem);
        return (true);
      } else {
        print('no entro');
        return (false);
      }
    } catch (e) {
      print('Errror en Crear Item: $e');
      return (false);
    }
  }

  //eliminar/Resolver Item
  Future<bool> eliminarItem(id) async {
    try {
      //Buscar en local
      var item = lostitem.firstWhere((objeto) => objeto.id == id);
      //Eliminar en BD
      await MongoDB.connect();
      if (await item.eliminarBD()) {
        //Eliminar en local
        lostitem.removeWhere((item) => item.id == id);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error al eliminar item: $e');
      return false;
    }
  }

  //Reclamar Item
  Future<bool> reclamarItem(String id) async {
    try {
      //Buscar en local
      var item = lostitem.firstWhere((objeto) => objeto.id == id);
      if (await item.reclamarBD()) {
        item.claimed = true;
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error al reclamar item $e');
      return false;
    }
  }

  //Buscaar Item en local
  LostItem itemxnombre(String title) {
    print(lostitem);
    LostItem item = lostitem.firstWhere((objeto) => objeto.title == title);
    return item;
  }

  List<LostItem> getlostitems() {
    return lostitem;
  }

  //Cargar 10 items de forma local
  Future<void> loaditemfromBD() async {
    try {
      LostItem commandblock = LostItem(
          id: 'command',
          title: 'title',
          tag: 'tag',
          tagColor: 'tagColor',
          imageUrl: 'imageUrl');
      lostitem.addAll(await commandblock.cargarnBD(10));
      print('Items en sistema: ${getlostitems()}');
    } catch (e) {
      print('Error en la carga local de items $e');
    }
  }
}
