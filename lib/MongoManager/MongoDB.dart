import 'dart:developer';

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
}
