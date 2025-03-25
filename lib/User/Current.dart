import 'User.dart';

class Current {
  static final Current _instance = Current._internal();
  User? currentUser;

  factory Current() {
    return _instance;
  }

  Current._internal();

  void setUser(User user) {
    currentUser = user;
  }

  void logout() {
    currentUser = null;
  }
}
