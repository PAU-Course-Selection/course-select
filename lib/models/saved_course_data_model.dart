import 'dart:collection';

import 'package:flutter/material.dart';

import 'course_data_model.dart';

/// The [SavedCoursesNotifier] class holds a list of favorite items saved by the user.
class SavedCoursesNotifier extends ChangeNotifier {
  late List<Course> _savedCourses = [];

  ///A getter for the list of courses
  List<Course> get savedCourses => (_savedCourses);

  ///Sets or updates list downloaded from the database using the model api
  set savedCourses(List<Course> list) {
    _savedCourses = list;
    notifyListeners();
  }

  void add(Course course) {
    _savedCourses.add(course);
    notifyListeners();
  }

  void remove(Course course) {
    _savedCourses.remove(course);
    notifyListeners();
  }
}