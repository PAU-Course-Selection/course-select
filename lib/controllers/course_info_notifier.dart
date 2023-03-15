import 'package:course_select/models/course_data_model.dart';
import 'package:flutter/material.dart';

class CourseInfoNotifier extends ChangeNotifier{
  Course? _currentCourse;

  set currentCourse(Course course){
    _currentCourse = course;
  }
}