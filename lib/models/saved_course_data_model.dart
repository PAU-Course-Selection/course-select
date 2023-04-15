import 'dart:collection';

import 'package:flutter/material.dart';

import 'course_data_model.dart';

/// The [SavedCoursesNotifier] class holds a list of favorite items saved by the user.
class SavedCoursesNotifier extends ChangeNotifier {
  late List<Course> _savedCourses = [];

  ///A getter for the list of courses, gets [_savedCourses].
  List<Course> get savedCourses => (_savedCourses);

  ///Sets or updates list downloaded from the database using the model api, updates [_savedCourses].
  set savedCourses(List<Course> list) {
    _savedCourses = list;
    notifyListeners();
  }
/// Adds a new course to the saved courses list, adds a new course to [_savedCourses].
  void add(Course course) {
    _savedCourses.add(course);
    notifyListeners();
  }
  /// Removes a  course from the saved courses list, removes course from [_savedCourses].
  void remove(Course course) {
    _savedCourses.remove(course);
    notifyListeners();
  }
}