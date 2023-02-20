import 'dart:collection';

import 'package:course_select/models/course_data_model.dart';
import 'package:get/get.dart';

class CourseController extends GetxController {
  List<Course> _courseList = [];
  Course? currentCourse;

  UnmodifiableListView<Course> get courseList =>
      UnmodifiableListView(_courseList);

  set courseList(List<Course> list) {
    _courseList = list;
  }


}