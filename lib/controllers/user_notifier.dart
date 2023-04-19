import 'dart:collection';

import 'package:course_select/utils/firebase_data_management.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:course_select/models/user_data_model.dart' as student;
import 'package:intl/intl.dart';

import '../models/course_data_model.dart';
import '../utils/auth.dart';

///[UserNotifier] creates a controller class with user attributes which notify all widgets of changes
class UserNotifier extends ChangeNotifier {
  final User? user = Auth().currentUser;
  final DatabaseManager db = DatabaseManager();

  var _userName = '';
  var _avatar =
      'https://firebasestorage.googleapis.com/v0/b/agileproject-76bf9.appspot.com/o/User%20Data%2Fuser.png?alt=media&token=0b4c347c-e8d9-456c-b76a-b02f2e4080a0';
  var _email = 'example@gmail.com';
  var _joinDate = '00-00-0000';

  List<student.UserModel> _usersList = [];
  List<student.UserModel> _userClassmates = [];

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

  /// A getter for the authenticated email
  /// returns [_email]
  get email => _email;

  /// A getter for the authenticated user's avatar image
  /// returns [_avatar]
  get avatar => _avatar;

  /// A getter for the authenticated user's name
  /// returns [_userName]
  get userName => _userName;

  /// A getter for the authenticated user's name
  /// returns [_studentLevel]
  int get studentLevel => _studentLevel;

  /// A setter for the authenticated user's skill level
  /// sets value for [_studentLevel]
  set studentLevel(int value) {
    _studentLevel = value;
    notifyListeners();
  }

  /// A setter for the authenticated user's list of subject areas they are interested in
  /// sets values for list of interests [_userInterests]
  set userInterests(List value) {
    _userInterests = value;
    notifyListeners();
  }


  ///A getter for the list of interests
  /// returns [_userInterests]
  List get userInterests => (_userInterests);

  ///A getter for the list of users registered on the same course as the current user
  /// returns [_userClassmates]
  UnmodifiableListView<student.UserModel> get userClassmates =>
      UnmodifiableListView(_userClassmates);

  ///A setter for the list of users registered on the same course as the current user
  /// updates [_userClassmates]
  set userClassmates(List<student.UserModel> list) {
    _userClassmates = list;
    notifyListeners();
  }

  ///A getter for the list of ids of courses the current user is registered on
  /// returns [_userCourseIds]
  List get userCourseIds => _userCourseIds;

  set userCourseIds(List value) {
    _userCourseIds = value;
    notifyListeners();
  }


  /// A getter for the list of users
  /// returns [_usersList]
  UnmodifiableListView<student.UserModel> get usersList =>
      UnmodifiableListView(_usersList);

  /// A setter for the current user's email address
  /// updates [_email]
  set email(value) {
    _email = value;
    notifyListeners();
  }

  ///Sets the user's name to be updated and used across different screens
  setUserName(String name) {
    _userName;
    notifyListeners();
  }
  /// A setter for the current user's name
  /// updates [_userName]
  set userName(value) {
    _userName = value;
    notifyListeners();
  }

  set password(value){

  }
  /// A setter for the current user's avatar image
  /// updates [_avatar]
  set avatar(value) {
    _avatar = value;
    notifyListeners();
  }

  ///Sets or updates list downloaded from the database using the model api
  set usersList(List<student.UserModel> list) {
    _usersList = list;
    notifyListeners();
  }

  /// updates the current users details in the database
  /// updates name, email, password, avatar and join date
  /// This is used on registration
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

  /// gets the current users join data
  /// return [_joinDate]
  get joinDate => _joinDate;

  /// sets the current users join data
  /// updates [_joinDate]
  set joinDate(value) {
    _joinDate = value;
    notifyListeners();
  }

  bool match = false;

  ///Gets a list of course ids for the current user from the database
  ///  returns a list of course ids
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
  /// Gets a list of interests from the database for the current user if found
  /// Returns a list of interests
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

  /// returns the current student's skill level as an integer from 1 to 3 or sets to 0 if not found
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

  /// Filters courses from [getCourseIds] by id
  /// returns a list of filtered courses
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


  /// A setter for the current user's skill level
  /// updates [_skillLevel]
  set skillLevel(List value) {
    _skillLevel = value;
    notifyListeners();
  }
}
