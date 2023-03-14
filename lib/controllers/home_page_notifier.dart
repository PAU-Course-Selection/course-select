import 'package:flutter/cupertino.dart';

class HomePageNotifier extends ChangeNotifier{
  bool _isFilterVisible = false;

  bool get isFilterVisible => _isFilterVisible;

  set isFilterVisible(bool value) {
    _isFilterVisible = value;
    notifyListeners();
  }
}