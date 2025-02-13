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
      String collectionName, SelectorBuilder? selector) async {
    var collection = _db.collection(collectionName);
    if (selector != null) {
      return await collection.findOne(selector);
    }
    return await collection.findOne();
  }

  Future<List<Map<String, dynamic>>> findManyFrom(
      String collectionName, SelectorBuilder? selector) async {
    var collection = _db.collection(collectionName);
    if (selector != null) {
      return await collection.find(selector).toList();
    }

    return await collection.find().toList();
  }

  //TODO testing
  Future<void> updateOneFrom(String collectionName, SelectorBuilder selector,
      ModifierBuilder modifier) async {
    var collection = _db.collection(collectionName);
    await collection.updateOne(selector, modifier);
  }

  //TODO testing
  Future<void> updateManyFrom(String collectionName, SelectorBuilder selector,
      ModifierBuilder modifier) async {
    var collection = _db.collection(collectionName);
    await collection.updateMany(selector, modifier);
  }

//TODO testing
  Future<void> replaceFrom(String collectionName, SelectorBuilder selector,
      Map<String, dynamic> newDocument) async {
    var collection = _db.collection(collectionName);
    await collection.replaceOne(selector, newDocument);
  }

  //TODO testing
  void deleteOneFrom(String collectionName, SelectorBuilder selector) {
    var collection = _db.collection(collectionName);
    collection.deleteOne(selector);
  }

  //TODO testing
  void deleteManyFrom(String collectionName, SelectorBuilder selector) {
    var collection = _db.collection(collectionName);
    collection.deleteMany(selector);
  }
}
