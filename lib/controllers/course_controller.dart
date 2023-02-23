import 'dart:collection';
import 'package:course_select/models/course_data_model.dart';
import 'package:get/get.dart';

///Creates a controller class with attributes which notify all widgets of changes
class CourseController extends GetxController {
  List<Course> _courseList = [];
  Course? currentCourse;

  ///A getter for the list of courses
  UnmodifiableListView<Course> get courseList =>
      UnmodifiableListView(_courseList);

  ///Sets or updates list downloaded from the database using the model api
  set courseList(List<Course> list) {
    _courseList = list;
  }


}