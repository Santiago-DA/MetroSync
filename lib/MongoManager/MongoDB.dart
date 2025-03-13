import 'package:mongo_dart/mongo_dart.dart';
import 'package:metrosync/MongoManager/Constant.dart';

class MongoDB {
  static var db, userCollection;

  MongoDB();

  // Getter para verificar si la conexión está abierta
  static bool get isConnected => db != null && db.state == State.OPEN;

  static Future<void> connect() async {
    if (!isConnected) {
      db = await Db.create(MONGO_URL);
      await db.open();
      userCollection = db.collection(USERS_COLLECTION);
      print('Conexión a MongoDB establecida.');
    }
  }

  static Future<void> close() async {
    if (isConnected) {
      await db.close();
      print('Conexión a MongoDB cerrada.');
    }
  }

  // Método para asegurar que la conexión esté abierta
  static Future<void> _ensureConnected() async {
    if (!isConnected) {
      await connect();
    }
  }

  DbCollection getCollection(String collectionName) {
    return db.collection(collectionName);
  }

  Future<void> insertInto(
      String collectionName, Map<String, dynamic> document) async {
    await _ensureConnected(); // Asegurar conexión
    var collection = getCollection(collectionName);
    await collection.insertOne(document);
  }

  Future<Map<String, dynamic>?> findOneFrom(
      String collectionName, SelectorBuilder? selector) async {
    await _ensureConnected(); // Asegurar conexión
    var collection = getCollection(collectionName);
    if (selector != null) {
      return await collection.findOne(selector);
    }
    return await collection.findOne();
  }

  Future<List<Map<String, dynamic>>> findManyFrom(
      String collectionName, SelectorBuilder? selector) async {
    await _ensureConnected(); // Asegurar conexión
    var collection = getCollection(collectionName);
    if (selector != null) {
      return await collection.find(selector).toList();
    }
    return await collection.find().toList();
  }

  Future<void> updateOneFrom(String collectionName, SelectorBuilder selector,
      ModifierBuilder modifier) async {
    await _ensureConnected(); // Asegurar conexión
    var collection = getCollection(collectionName);
    await collection.updateOne(selector, modifier);
  }

  Future<void> updateManyFrom(String collectionName, SelectorBuilder selector,
      ModifierBuilder modifier) async {
    await _ensureConnected(); // Asegurar conexión
    var collection = getCollection(collectionName);
    await collection.updateMany(selector, modifier);
  }

  Future<void> replaceFrom(String collectionName, SelectorBuilder selector,
      Map<String, dynamic> newDocument) async {
    await _ensureConnected(); // Asegurar conexión
    var collection = getCollection(collectionName);
    await collection.replaceOne(selector, newDocument);
  }

  Future<void> deleteOneFrom(
      String collectionName, SelectorBuilder selector) async {
    await _ensureConnected(); // Asegurar conexión
    var collection = getCollection(collectionName);
    await collection.deleteOne(selector);
  }

  Future<void> deleteManyFrom(
      String collectionName, SelectorBuilder selector) async {
    await _ensureConnected(); // Asegurar conexión
    var collection = getCollection(collectionName);
    await collection.deleteMany(selector);
  }
}
