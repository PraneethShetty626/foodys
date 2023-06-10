import 'package:flutter/cupertino.dart';

class CurrentSection with ChangeNotifier {
  int cs = 0;

  void setSection(int c) {
    cs = c;
    notifyListeners();
  }
}
