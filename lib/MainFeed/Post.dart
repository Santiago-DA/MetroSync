import '../MongoManager/MongoDB.dart';

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

  //Future<void> insertPostInDB() async {
  // try {
  //   await MongoDB.connect(); //conectar
  //   //genero el documento
  //  var postDocumment = {
  //    "username": _username,
  //   "tittle": _tittle,
  //   "description": _description,
  //    "label": _label,
  //    "date": date,
  //  };
  //} catch (e) {
  //   print("error insertanto post $e");
  //} finally {
  //  MongoDB.close();
  //}
  //}
}
