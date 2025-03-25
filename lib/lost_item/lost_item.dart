import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import '../MongoManager/Constant.dart';
import '../MongoManager/MongoDB.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class LostItem {
  final String id;
  final String title;
  final String tag;
  final String tagColor;
  final String imageBase64;
  bool claimed = false;
  final MongoDB db = MongoDB();

  LostItem({
    required this.id,
    required this.title,
    required this.tag,
    required this.tagColor,
    required this.imageBase64,
  });

  @override
  String toString() {
    return 'id: $id, claimed: $claimed, title: $title, tag: $tag, tagColor: $tagColor';
  }

  factory LostItem.fromMap(Map<String, dynamic> map) {
    return LostItem(
      id: map['_id'].toString(),
      title: map['title'] ?? '',
      tag: (map['tag'] ?? ''),
      tagColor: (map['tagColor']),
      imageBase64: (map['imageBase64'] ?? ''),
    );
  }


  static Future<String?> compressAndConvertImage(File imageFile) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final targetPath = '${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg';


      final result = await FlutterImageCompress.compressAndGetFile(
        imageFile.absolute.path,
        targetPath,
        quality: 70,
        minWidth: 800,
        minHeight: 800,
        rotate: 0,
        format: CompressFormat.jpeg,
      );

      if (result == null) return null;

      final bytes = await result.readAsBytes();
      return base64Encode(bytes);
    } catch (e) {
      print('Error en la compresión: $e');
      return null;
    }
  }


  Future<bool> guardarBD() async {
    try {
      await MongoDB.connect();

      var newItem = {
        '_id': id,
        'title': title,
        'tag': tag,
        'tagColor': tagColor,
        'imageBase64': imageBase64,
        'claimed': claimed,
      };
      await db.insertInto(LostItems, newItem);
      return true;
    } catch (e) {
      print('Error al guardar item en BD: $e');
      return false;
    }
  }


  Image get compressedImage {
    return Image.memory(
      base64Decode(imageBase64),
      width: 200,
      height: 200,
      fit: BoxFit.cover,
    );
  }


  Future<bool> eliminarBD() async {
    try {
      await MongoDB.connect();
      await db.deleteOneFrom(LostItems, where.eq('_id', id));
      return true;
    } catch (e) {
      print('Error al eliminar item en BD $e');
      return false;
    }
  }

  Future<bool> reclamarBD() async {
    try {
      await MongoDB.connect();
      await db.updateOneFrom(
          LostItems, where.eq('_id', id), modify.set('claimed', true));
      return true;
    } catch (e) {
      print('Error al reclamar item en BD $e');
      return false;
    }
  }

  Future<List<LostItem>> cargarnBD(int n) async {
    try {
      List<LostItem> list = [];
      await MongoDB.connect();

      print('Fetching $n unclaimed items from DB...');


      var DBlist = await db.findNFromif(LostItems, n, where.eq('claimed', false));
      list.addAll(DBlist.map((doc) => LostItem.fromMap(doc)));

      print('Loaded ${list.length} unclaimed items successfully');

      return list;
    } catch (e) {
      print('Error al cargar objetos de la BD: $e');
      return [];
    }
  }

  Future<List<LostItem>> cargarntagsBD(int n, String tag) async {
    try {
      List<LostItem> list = [];
      await MongoDB.connect();
      var DBlist = await db.findNFromif(
          LostItems,
          n,
          where.eq('tag', tag).eq('claimed', false) // Adjust field name if needed
      );
      list.addAll(DBlist.map((doc) => LostItem.fromMap(doc)));
      return list;
    } catch (e) {
      print('Error al cargar objetos de la BD $e');
      return [];
    }
  }

}