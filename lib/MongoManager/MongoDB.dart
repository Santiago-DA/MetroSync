import 'dart:developer';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:flutter_prueba/MongoManager/Constant.dart';

class MongoDB {
  static connect() async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    inspect(db);
    var status = db.serverStatus();
    var userCollection = db.collection(USERS_COLLECTION);
  }
}
