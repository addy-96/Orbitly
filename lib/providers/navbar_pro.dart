import 'package:flutter/material.dart';

class NavbarPro extends ChangeNotifier {
  int _index = 0;

  int get index => _index;

  void changeIndex(int index) {
    _index = index;
    notifyListeners();
  }
}
