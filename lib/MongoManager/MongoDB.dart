import 'package:mongo_dart/mongo_dart.dart';
import 'package:metrosync/MongoManager/Constant.dart';

class MongoDB {
  static var db,userCollection;

  MongoDB();
  static Future<void> connect() async {
    if (db == null || db.state != State.OPEN) {
      db = await Db.create(MONGO_URL);
      await db.open();
      userCollection = db.collection(USERS_COLLECTION);
      print('Conexión a MongoDB establecida.');
    }
  }

  static Future<void> close() async {
    if (db != null && db.state == State.OPEN) {
      await db.close();
      print('Conexión a MongoDB cerrada.');
    }
  }


  DbCollection getCollection(String collectionName) {
    DbCollection collection = db.collection(collectionName);
    return collection;
  }



  Future<void> insertInto(
      String collectionName, Map<String, dynamic> document) async {
    var collection = db.collection(collectionName);
    await collection.insertOne(document);
  }

  Future<Map<String, dynamic>?> findOneFrom(
      String collectionName, SelectorBuilder? selector) async {
    var collection = db.collection(collectionName);
    if (selector != null) {
      return await collection.findOne(selector);
    }
    return await collection.findOne();
  }

  Future<List<Map<String, dynamic>>> findManyFrom(
      String collectionName, SelectorBuilder? selector) async {
    var collection = db.collection(collectionName);
    if (selector != null) {
      return await collection.find(selector).toList();
    }

    return await collection.find().toList();
  }

  //TODO testing
  Future<void> updateOneFrom(String collectionName, SelectorBuilder selector,
      ModifierBuilder modifier) async {
    var collection = db.collection(collectionName);
    await collection.updateOne(selector, modifier);
  }

  //TODO testing
  Future<void> updateManyFrom(String collectionName, SelectorBuilder selector,
      ModifierBuilder modifier) async {
    var collection = db.collection(collectionName);
    await collection.updateMany(selector, modifier);
  }

//TODO testing
  Future<void> replaceFrom(String collectionName, SelectorBuilder selector,
      Map<String, dynamic> newDocument) async {
    var collection = db.collection(collectionName);
    await collection.replaceOne(selector, newDocument);
  }

  //TODO testing
  void deleteOneFrom(String collectionName, SelectorBuilder selector) {
    var collection = db.collection(collectionName);
    collection.deleteOne(selector);
  }

  //TODO testing
  void deleteManyFrom(String collectionName, SelectorBuilder selector) {
    var collection = db.collection(collectionName);
    collection.deleteMany(selector);
  }
}
