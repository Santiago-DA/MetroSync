import 'package:mongo_dart/mongo_dart.dart';
import 'package:metrosync/MongoManager/MongoDB.dart'; // Asegúrate de importar MongoDB

class Deal {
  final String usuario;
  final String promocion;
  final String imagen;
  final List<Map<String, String>> menu;

  Deal({
    required this.usuario,
    required this.promocion,
    required this.imagen,
    required this.menu,
  });

  // Método para convertir un Map en un objeto Deal
  factory Deal.fromMap(Map<String, dynamic> map) {
    return Deal(
      usuario: map['usuario'] as String,
      promocion: map['promocion'] as String,
      imagen: map['imagen'] as String,
      menu: List<Map<String, String>>.from(map['menu']),
    );
  }

  // Método para convertir un objeto Deal en un Map
  Map<String, dynamic> toMap() {
    return {
      'usuario': usuario,
      'promocion': promocion,
      'imagen': imagen,
      'menu': menu,
    };
  }

  // Método estático para guardar un Deal en MongoDB
  static Future<void> saveDeal(Deal deal) async {
    await MongoDB.connect();
    await MongoDB().insertInto("Deals", deal.toMap());
    print('Deal guardado en MongoDB.');
  }

  // Método estático para obtener todos los Deals desde MongoDB
  static Future<List<Deal>> getDeals() async {
    await MongoDB.connect();
    var dealsData = await MongoDB().findManyFrom("Deals", null);
    return dealsData.map((dealMap) => Deal.fromMap(dealMap)).toList();
  }
}