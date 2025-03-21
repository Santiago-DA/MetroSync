import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import '../MongoManager/Constant.dart';
import '../MongoManager/MongoDB.dart';
class LostItem {
  final String id;
  final String title; // Título del objeto
  final String tag; // Etiqueta
  final String tagColor; // Color de la etiqueta
  final String imageUrl; // URL de la imagen
  bool claimed=false;
  final MongoDB db =MongoDB();

  LostItem({
    required this.id,
    required this.title,
    required this.tag,
    required this.tagColor,
    required this.imageUrl,
  });

  @override
  String toString(){
    return 'id: $id, claimed: $claimed, title: $title, tag: $tag, tagColor: $tagColor, imageUrl: $imageUrl';    
  }

  factory LostItem.fromMap(Map<String, dynamic> map) {
    return LostItem(
      id: map['_id'].toString(),
      title: map['title'] ?? '',
      tag: (map['tag'] ?? ''),
      tagColor: (map['tagColor']),
      imageUrl: (map['imageUrl'])
    );
  }

  //Guardar en BD
  Future<bool> guardarBD() async{
    try{
      await MongoDB.connect();
      var newtiem= {
        '_id': id,
        'title':title,
        'tag':tag,
        'tagColor':tagColor,
        'imageUrl':imageUrl,
        'claimed':claimed,
      };
      await db.insertInto(LostItems, newtiem);
      return(true);
    }catch(e){
      print('Error al guardar item en BD: $e');
      return(false);
    }
  }

  //Borrar en BD
  Future<bool> eliminarBD() async{
    try{
      //Establecer conexion
      await MongoDB.connect();
      //Buscar y borrar
      await db.deleteOneFrom(LostItems, (where.eq('id', id)));
      return true;
    }catch(e){
      print('Erorr al eliminar item en BD $e');
      return false;
    }
  }

  //Reclamar en BD
  Future<bool> reclamarBD() async{
    try{
      //Conectar a BD
      await MongoDB.connect();
      //Reclamar en BD
      await db.updateOneFrom(LostItems,where.eq('id', id),modify.set('claimed', true));
      return true;
    }catch(e){
      print('Error al reclamar item en BD $e');
      return false;
    }
  }

  //Cargar n desde BD
  Future<List<LostItem>> cargarnBD(int n) async{
    try{
      //Crear lista vacia
      List<LostItem> list=[];
      //Conectar a la BD
      await MongoDB.connect();
      //Agregar 10 elementos
      var DBlist =await db.findNFrom(LostItems, n);
      list.addAll(DBlist.map((doc) => LostItem.fromMap(doc)));
      return list;
    }catch(e){
      print('Error al cargar objetos de la BD $e');
      List<LostItem> d = [];
      return d;
    }
  }
}
