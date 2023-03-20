import 'dart:collection';

import 'package:course_select/utils/firebase_data_management.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:course_select/models/user_data_model.dart' as student;

import '../utils/auth.dart';
///Creates a controller class with user attributes which notify all widgets of changes
class UserNotifier extends ChangeNotifier {
  final User? user = Auth().currentUser;
  final DatabaseManager db = DatabaseManager();

  var _userName = '';
  var _avatar = 'https://firebasestorage.googleapis.com/v0/b/agileproject-76bf9.appspot.com/o/User%20Data%2Fuser.png?alt=media&token=0b4c347c-e8d9-456c-b76a-b02f2e4080a0';
  var _email = 'example@gmail.com';
  var _joinDate = '00-00-0000';

  get email => _email;
  get avatar => _avatar;
  ///A getter for the authenticated user's name
  get userName => _userName;

  List<student.UserModel> _usersList = [];
  student.UserModel? currentCourse;

  ///A getter for the list of users
  UnmodifiableListView<student.UserModel> get usersList =>
      UnmodifiableListView(_usersList);

  set email(value) => _email = value;
  ///Sets the user's name to be updated and used across different screens
  setUserName(String name) {
    _userName;
    notifyListeners();
  }

  set userName(value) {
    _userName = value;
    notifyListeners();
  }

  set avatar(value) {
    _avatar = value;
    notifyListeners();
  }

  ///Sets or updates list downloaded from the database using the model api
  set usersList(List<student.UserModel> list) {
    _usersList = list;
    notifyListeners();
  }

  void updateUserName() {
    for(var student in usersList){
      if (student.email == user?.email){
        userName = student.displayName ?? '';
      }
    }
    notifyListeners();
  }
  void updateAvatar(){
    try {
      for (var student in usersList) {
        if (student.email == user?.email) {
           avatar = student.avatar?? '';
        }
      }
    }on ArgumentError catch(e) {
      print(e);
    }
    notifyListeners();
  }

  void updateDate() {
    for (var student in usersList) {
      if (student.email == user?.email) {
        DateTime? date = student.dateCreated?.toDate();
        String? year = date?.year.toString();
        String? month = date?.month.toString();
        String? day = date?.day.toString();
        joinDate = "Joined on $year-$month-$day";
      }
    }
    notifyListeners();
  }

  void updateEmail(){
    email = user?.email ?? 'User email';
    notifyListeners();
  }


  get joinDate => _joinDate;

  set joinDate(value) {
    _joinDate = value;
  }
}