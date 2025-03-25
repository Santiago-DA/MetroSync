import 'package:uuid/uuid.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:metrosync/MongoManager/MongoDb.dart';
import '../User/User.dart';
import '../lost_item/lost_item.dart';

class VM extends ChangeNotifier {
  User _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  List<LostItem> lostitem = [];
  List<String> adminnegocios = [
    'holyshakes',
    'mipuntgrill',
    'TEEB',
    'elcalvopizza'
  ];
  List<String> adminobjetos = ['objetosperdidos'];

  VM() : _currentUser = User();

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
      } else {
        _errorMessage = 'Credenciales inválidas';
      }

      _isLoading = false;
      notifyListeners();
      return success;
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

  Future<bool> crearItem(String title, String tag, File imageFile) async {
    try {
      var uuid = Uuid();
      String id = uuid.v4();
      String? compressedImage = await LostItem.compressAndConvertImage(imageFile);

      if (compressedImage == null) {
        print('Failed to compress image');
        return false;
      }

      String tagColor = _getTagColor(tag);

      LostItem newItem = LostItem(
          id: id, title: title, tag: tag, tagColor: tagColor, imageBase64: compressedImage);

      await MongoDB.connect();
      bool success = await newItem.guardarBD();

      if (success) {
        lostitem.add(newItem);
        notifyListeners(); // Notify UI of changes
        print('Item created successfully');
        return true;
      } else {
        print('Failed to save item to database');
        return false;
      }
    } catch (e) {
      print('Error creating item: $e');
      return false;
    }
  }

  String _getTagColor(String tag) {
    switch (tag.toLowerCase()) {
      case 'electronics':
        return 'blue';
      case 'documents':
        return 'red';
      case 'clothing':
        return 'green';
      default:
        return 'gray';
    }
  }

  Future<bool> eliminarItem(String id) async {
    try {
      var item = lostitem.firstWhere((objeto) => objeto.id == id);

      await MongoDB.connect();
      if (await item.eliminarBD()) {
        lostitem.removeWhere((item) => item.id == id);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Error deleting item: $e');
      return false;
    }
  }

  Future<bool> reclamarItem(String id) async {
    try {
      var item = lostitem.firstWhere((objeto) => objeto.id == id);

      if (await item.reclamarBD()) {
        item.claimed = true;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Error claiming item: $e');
      return false;
    }
  }

  LostItem itemxnombre(String title) {
    return lostitem.firstWhere((objeto) => objeto.title == title);
  }

  List<LostItem> getlostitems() {
    return lostitem;
  }

  Future<void> loaditemfromBD() async {
    try {
      LostItem loader = LostItem(id: 'loader', title: 'loader', tag: 'loader', tagColor: 'loader', imageBase64: '');

      List<LostItem> newItems = await loader.cargarnBD(10);

      // Remove duplicates before updating
      var uniqueItems = {for (var item in newItems) item.id: item}.values.toList();
      lostitem.clear();
      lostitem.addAll(uniqueItems);

      notifyListeners();
      print('Loaded ${lostitem.length} items from DB');
    } catch (e) {
      print('Error loading items: $e');
    }
  }

  Future<void> loaditemwithtags(String tag) async {
    try {
      LostItem loader = LostItem(id: 'loader', title: 'loader', tag: 'loader', tagColor: 'loader', imageBase64: '');

      List<LostItem> filteredItems = await loader.cargarntagsBD(10, tag);

      // Ensure no duplicates in the list
      var uniqueItems = {for (var item in filteredItems) item.id: item}.values.toList();
      lostitem.clear();
      lostitem.addAll(uniqueItems);

      notifyListeners();
    } catch (e) {
      print('Error loading tagged items: $e');
    }
  }
}
