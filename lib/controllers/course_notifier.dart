import 'dart:collection';
import 'package:course_select/controllers/user_notifier.dart';
import 'package:course_select/models/course_data_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../utils/firebase_data_management.dart';

///Creates a controller class with attributes which notify all widgets of changes
class CourseNotifier extends ChangeNotifier {

  List<Course> _courseList = <Course>[];
  Course? _currentCourse;

  set currentCourse(Course course) {
    _currentCourse = course;
    notifyListeners();
  }

  ///A getter for the list of courses
  UnmodifiableListView<Course> get courseList =>
      UnmodifiableListView(_courseList);

  ///Sets or updates list downloaded from the database using the model api
  set courseList(List<Course> list) {
    _courseList = list;
    notifyListeners();
  }




}