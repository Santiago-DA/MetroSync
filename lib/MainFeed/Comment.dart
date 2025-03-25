class Comment {
  String username;
  String tittle;
  String description;
  late final String date;
  Comment(
      {required this.description,
      required this.tittle,
      required this.username}) {
    date = DateTime.now().toString();
  }
}
