import 'package:flutter/material.dart';

/// The [SavedCourses] class holds a list of favorite items saved by the user.
class SavedCourses extends ChangeNotifier {
  final List<String> _savedCourses = [];

  List<String> get savedCourses => _savedCourses;

  void add(String courseId) {
    _savedCourses.add(courseId);
    notifyListeners();
  }

  void remove(String courseId) {
    _savedCourses.remove(courseId);
    notifyListeners();
  }
}