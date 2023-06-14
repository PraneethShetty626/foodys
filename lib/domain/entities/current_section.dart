import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrentSection with ChangeNotifier {
  int cs = 0;

  void setSection(int c) {
    cs = c;
    notifyListeners();
  }
}

class LoggedIn with ChangeNotifier {
  SharedPreferences? instance;
  bool loggedIn = false;

  LoggedIn() {
    SharedPreferences.getInstance().then((value) {
      instance = value;
    });
  }

  void setTrue(String value) {
    instance!.setString("key", value);
    loggedIn = !loggedIn;
    notifyListeners();
  }

  void setStatus() {
    loggedIn = instance?.getString("key") == null ? false : true;
    notifyListeners();
  }

  void logout() {
    instance?.remove("key");
    loggedIn = false;
    notifyListeners();
  }
}
