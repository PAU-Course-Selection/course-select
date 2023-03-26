import 'package:flutter/cupertino.dart';

class HomePageNotifier extends ChangeNotifier{
  bool _isFilterVisible = false;
  bool _isAllSelected = false;
  bool _isOngoingSelected = false;
  bool _isCompletedSelected = false;
  int _tabIndex = 0;
  late String _docId;

  String get docId => _docId;

  set docId(String value) {
    _docId = value;
    notifyListeners();
  }

  int get tabIndex => _tabIndex;

  set tabIndex(int value) {
    _tabIndex = value;
    notifyListeners();
  }

  bool get isFilterVisible => _isFilterVisible;

  bool get isAllSelected => _isAllSelected;

  set isAllSelected(bool value) {
    _isAllSelected = value;
    notifyListeners();
  }

  set isFilterVisible(bool value) {
    _isFilterVisible = value;
    notifyListeners();
  }

  bool get isOngoingSelected => _isOngoingSelected;

  set isOngoingSelected(bool value) {
    _isOngoingSelected = value;
    notifyListeners();
  }

  bool get isCompletedSelected => _isCompletedSelected;

  set isCompletedSelected(bool value) {
    _isCompletedSelected = value;
    notifyListeners();
  }
}