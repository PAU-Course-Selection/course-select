import 'package:flutter/cupertino.dart';

class HomePageNotifier extends ChangeNotifier{
  bool _isFilterVisible = false;
  bool _isAllSelected = false;
  bool _isOngoingSelected = false;
  bool _isCompletedSelected = false;
  int _tabIndex = 0;
  late String _docId;
  late bool _isStateChanged = false;

  ///Gets the indicator of the change of state of the home page
  bool get isStateChanged => _isStateChanged;

  ///Sets the indicator of a state change on the home page
  set isStateChanged(bool value) {
    _isStateChanged = value;
    notifyListeners();
  }

  ///Gets the document id
  String get docId => _docId;

  ///Sets the document id
  set docId(String value) {
    _docId = value;
    notifyListeners();
  }

  ///Gets the tab index for the bottom navigation bar
  int get tabIndex => _tabIndex;


  ///Sets the tab index for the bottom navigation bar
  set tabIndex(int value) {
    _tabIndex = value;
    notifyListeners();
  }

  /// get the status of whether the filter menu is visible or not
  bool get isFilterVisible => _isFilterVisible;

  /// Get whether all course are displayed/selected or not
  bool get isAllSelected => _isAllSelected;

  /// Set whether all courses are displayed/selected or not
  set isAllSelected(bool value) {
    _isAllSelected = value;
    notifyListeners();
  }

  /// Set whether filters are visible or not
  set isFilterVisible(bool value) {
    _isFilterVisible = value;
    notifyListeners();
  }

  /// Get whether an ongoing course is selected
  bool get isOngoingSelected => _isOngoingSelected;

  /// Set whether an ongoing course is selected
  set isOngoingSelected(bool value) {
    _isOngoingSelected = value;
    notifyListeners();
  }

  /// Get whether a completed course is selected
  bool get isCompletedSelected => _isCompletedSelected;

  /// Set whether a completed course is selected
  set isCompletedSelected(bool value) {
    _isCompletedSelected = value;
    notifyListeners();
  }
}