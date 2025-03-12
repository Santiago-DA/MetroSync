import 'package:mongo_dart/mongo_dart.dart';

import '../MongoManager/MongoDB.dart';
import 'package:metrosync/MainFeed/Comment.dart';

class Post {
  String? _username;
  String? _tittle;
  String? _description;
  String? _label;
  List<Map<String, String>> _comments = [];
  late final String date;
  final MongoDB _db = MongoDB();

  Post(this._username, this._tittle, this._description, this._label) {
    date = DateTime.now().toString();
  }

  Future<void> insertPostInDB() async {
    try {
      await MongoDB.connect(); //conectar

      var postDocumment = {
        "username": _username,
        "tittle": _tittle,
        "description": _description,
        "label": _label,
        "date": date,
        "comments": _comments
      };
      await _db.insertInto("Posts", postDocumment);
      return;
    } catch (e) {
      print("error insertanto post $e");
    } finally {
      MongoDB.close();
    }
  }

  //insertar comentario al Post no a la BDD

  void addComment(Comment comment) {
    Map<String, String> comment_doc = {
      "username": comment.username,
      "tittle": comment.description,
      "description": comment.description,
      "date": comment.date,
    };
    _comments.add(comment_doc);
  }

  Future<void> updateCommentsInDB() async {
    try {
      await MongoDB.connect(); //conectar
      await _db.updateOneFrom(
          "Posts", where.eq("date", date), modify.set("comments", _comments));
      return;
    } catch (e) {
      print("error actualizando post $e");
    } finally {
      MongoDB.close();
    }
  }
}
