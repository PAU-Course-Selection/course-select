import 'dart:collection';

import 'package:course_select/controllers/user_notifier.dart';
import 'package:course_select/utils/firebase_data_management.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:course_select/models/user_data_model.dart' as student;

import '../models/course_data_model.dart';
import '../models/lesson_data_model.dart';
import '../utils/auth.dart';

///Creates a controller class with user attributes which notify all widgets of changes
class LessonNotifier extends ChangeNotifier {

  var _lessonName = '';
  var _link = '';
///returns the lesson start time
  get startTime => _startTime;
/// sets the lesson start time
  set startTime(value) {
    _startTime = value;
  }

  final User? user = Auth().currentUser;
  List<Lesson> _userLessonsList = [];
  List<Lesson> _allLessonsList = [];

  List<Lesson> get allLessonsList => _allLessonsList;

  set allLessonsList(List<Lesson> value) {
    _allLessonsList = value;
    notifyListeners();
  }

  var _startTime = '00:00';
  var _endTime = '00:00';

  ///Gets the lesson name
  get lessonName => _lessonName;

  ///Sets the lesson name
  set lessonName(value) {
    _lessonName = value;
    notifyListeners();
  }

  /// Updates the lesson date and time for the current student
  void updateDate(LessonNotifier lessonNotifier, UserNotifier userNotifier) {
    for (var student in userNotifier.usersList) {
      if(student.email == user?.email){
        for (var lesson in lessonNotifier.userLessonsList) {
          DateTime? startDate = lesson.startTime?.toDate();
          String? timeHour = startDate?.hour.toString();
          String? timeMin = startDate?.hour.toString();

          DateTime? endDate = lesson.endTime?.toDate();
          String? timeHour2 = endDate?.hour.toString();
          String? timeMin2 = endDate?.hour.toString();

          startTime = "$timeHour:$timeMin";
          endTime = "$timeHour2:$timeMin2";
        }
      }
    }
    notifyListeners();
  }

  ///A getter for the list of lessons
  UnmodifiableListView<Lesson> get userLessonsList =>
      UnmodifiableListView(_userLessonsList);

  ///Sets or updates list downloaded from the database using the model api
  set userLessonsList(List<Lesson> list) {
    _userLessonsList = list;
    notifyListeners();
  }
///Gets the link to the lesson
  get link => _link;
///Sets the link to the lesson
  set link(value) {
    _link = value;
    notifyListeners();
  }

///Gets the lesson end time
  get endTime => _endTime;
/// Sets the Lesson end time
  set endTime(value) {
    _endTime = value;
    notifyListeners();
  }
}