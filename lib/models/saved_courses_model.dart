import 'package:flutter/material.dart';

/// The [SavedCourses] class holds a list of favorite items saved by the user.
class SavedCourses extends ChangeNotifier {
  final List<int> _savedCourses = [];

  List<int> get savedCourses => _savedCourses;

  void add(int courseId) {
    _savedCourses.add(courseId);
    notifyListeners();
  }

  void remove(int courseId) {
    _savedCourses.remove(courseId);
    notifyListeners();
  }
}