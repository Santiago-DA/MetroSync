import 'package:mongo_dart/mongo_dart.dart';
import 'package:flutter_prueba/MongoManager/Constant.dart';

class MongoDB {
  late Db _db;

  MongoDB();
  Future<dynamic> connect() async {
    _db = await Db.create(MONGO_URL);
    await _db.open();
  }

  DbCollection getCollection(String collectionName) {
    DbCollection collection = _db.collection(collectionName);
    return collection;
  }

  Future<void> close() async {
    await _db.close();
  }

  Future<void> insertInto(
      String collectionName, Map<String, dynamic> document) async {
    var collection = _db.collection(collectionName);
    await collection.insertOne(document);
  }

  Future<Map<String, dynamic>?> findOneFrom(
      String collectionName, SelectorBuilder? query) async {
    var collection = _db.collection(collectionName);
    if (query != null) {
      return await collection.findOne(query);
    }
    return await collection.findOne();
  }

  Future<List<Map<String, dynamic>>> findManyFrom(
      String collectionName, SelectorBuilder? query) async {
    var collection = _db.collection(collectionName);
    if (query != null) {
      return await collection.find(query).toList();
    }
    return await collection.find().toList();
  }
}
