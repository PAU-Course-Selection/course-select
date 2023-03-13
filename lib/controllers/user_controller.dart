import 'dart:collection';

import 'package:get/get.dart';
import 'package:course_select/models/user_data_model.dart' as student;
///Creates a controller class with user attributes which notify all widgets of changes
class UserController extends GetxController {
  var _userName = 'user'.obs;
  var _avatar = '';

  ///Sets the user's name to be updated and used across different screens
  setUserName(String name) {
    _userName(name);
  }

  set userName(value) {
    _userName = value;
  }

  set avatar(value) {
    _avatar = value;
  }

  ///A getter for the authenticated user's name
  get userName => _userName;

  List<student.User> _usersList = [];
  student.User? currentCourse;

  ///A getter for the list of users
  UnmodifiableListView<student.User> get usersList =>
      UnmodifiableListView(_usersList);

  ///Sets or updates list downloaded from the database using the model api
  set usersList(List<student.User> list) {
    _usersList = list;
  }
}