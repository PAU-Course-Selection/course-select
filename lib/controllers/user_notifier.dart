import 'dart:collection';

import 'package:course_select/firestore/firebase_data_management.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:course_select/models/user_data_model.dart' as student;
import 'package:intl/intl.dart';

import '../models/course_data_model.dart';
import '../auth/auth.dart';

///Creates a controller class with user attributes which notify all widgets of changes
class UserNotifier extends ChangeNotifier {
  final User? user = Auth().currentUser;
  final DatabaseManager db = DatabaseManager();

  var _userName = '';
  var _avatar =
      'https://firebasestorage.googleapis.com/v0/b/agileproject-76bf9.appspot.com/o/User%20Data%2Fuser.png?alt=media&token=0b4c347c-e8d9-456c-b76a-b02f2e4080a0';
  var _email = 'example@gmail.com';
  var _joinDate = '00-00-0000';

  get email => _email;
  get avatar => _avatar;
  ///A getter for the authenticated user's name
  get userName => _userName;

  List<student.UserModel> _usersList = [];
  List _userCourseIds = [];
  List _userInterests = [];
  List _skillLevel = [];
  int _studentLevel = 0;
  bool _isConflict = false;

  bool get isConflict => _isConflict;

  set isConflict(bool value) {
    _isConflict = value;
    notifyListeners();
  }

  int get studentLevel => _studentLevel;

  set studentLevel(int value) {
    _studentLevel = value;
    notifyListeners();
  }

  set userInterests(List value) {
    _userInterests = value;
    notifyListeners();
  }

  List<student.UserModel> _userClassmates = [];

  ///A getter for the list of interests
  List get userInterests => (_userInterests);

  ///A getter for the list of users
  UnmodifiableListView<student.UserModel> get userClassmates =>
      UnmodifiableListView(_userClassmates);

  ///Sets or updates list downloaded from the database using the model api
  set userClassmates(List<student.UserModel> list) {
    _userClassmates = list;
    notifyListeners();
  }

  List get userCourseIds => _userCourseIds;

  set userCourseIds(List value) {
    _userCourseIds = value;
    notifyListeners();
  }


  ///A getter for the list of users
  UnmodifiableListView<student.UserModel> get usersList =>
      UnmodifiableListView(_usersList);


  set email(value) {
    _email = value;
    notifyListeners();
  }

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

  void updateUserDetails() {
    try{
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user != null) {
          email = user.email;
          for (var student in usersList) {
            if (student.email == user.email) {
              userName = student.displayName ?? '';
              email = student.email ?? '';
              avatar = student.avatar ?? '';
              DateTime? date = student.dateCreated?.toDate();
              var formattedDate = DateFormat.yMEd().format(date?? DateTime.now());
              joinDate = "Joined on $formattedDate";
              break; // Stop searching once the user is found
            }
          }
        }
        notifyListeners();
      });
    }catch (e){
      print(e);
    }
  }

  get joinDate => _joinDate;
  set joinDate(value) {
    _joinDate = value;
    notifyListeners();
  }

  bool match = false;

  List getCourseIds() {
    List ids = [];
    for (int i = 0; i < usersList.length; i++) {
      if (usersList[i].email == user?.email) {
        match = true;
        ids = usersList[i].courses!;
        userCourseIds = ids;
      }
    }
    if (match) {
      print('user found!');
    } else {
      print('user not found');
    }
    return ids;
  }

  List getInterests() {
    List interests = [];
    for (int i = 0; i < usersList.length; i++) {
      if (usersList[i].email == user?.email) {
        match = true;
        // print(match);
        // print(usersList[i].email);
        interests = usersList[i].interests!;
        // userInterests = interests;
      }
    }
    if (match) {
      print('user interests found!');
    } else {
      print('user interests NOT found');
    }
    return interests.toList();
  }
  int getStudentLevel() {
    int level = 0;
    for (int i = 0; i < usersList.length; i++) {
      if (user != null && usersList[i].email == user?.email) {
        match = true;
        level = usersList[i].studentLevel ?? 0; // use a default value if skillLevel is null
        studentLevel = level;
      }
    }
    if (match) {
       print('getStudentLevel: $studentLevel');
    } else {
      print('user level NOT found');
    }
    return level;
  }




  List<Course> filterCoursesByIds(List<Course> courses) {
    List ids = getCourseIds();
    List<Course> filteredCourses = [];
    for (var course in courses) {
      //print(course.courseId);
      if (ids.contains(course.courseId)) {
        filteredCourses.add(course);
      }
    }
    return filteredCourses;
  }

  ///A getter for the list of levels
  List get skillLevel => (_skillLevel);



  set skillLevel(List value) {
    _skillLevel = value;
    notifyListeners();
  }
}
