class Comment {
  String? _username;
  String? _tittle;
  String? _description;
  late final String date;
  Comment() {
    date = DateTime.now().toString();
  }
}
