import 'package:course_select/controllers/course_notifier.dart';
import 'package:course_select/controllers/lesson_notifier.dart';
import 'package:course_select/models/course_data_model.dart';
import 'package:course_select/models/lesson_data_model.dart';
import 'package:course_select/models/user_data_model.dart' as student;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:intl/intl.dart';

import '../controllers/user_notifier.dart';
import '../models/saved_course_data_model.dart';
import 'auth.dart';

class DatabaseManager {
  final data = FirebaseFirestore.instance;
  late final CourseNotifier courseNotifier;
  late final SavedCoursesNotifier savedCourses;
  final User? user = Auth().currentUser;

  late Query<Map<String, dynamic>> favoritesQuery = FirebaseFirestore.instance
      .collection('Dummy')
      .where('dummyField', isEqualTo: 'dummyValue');

  Future<void> userSetup(
      {required String displayName, required String email}) async {
    CollectionReference users = data.collection('Users');
    FirebaseAuth auth = FirebaseAuth.instance;
    String? uid = auth.currentUser?.uid.toString();
    users.add({
      'displayName': displayName,
      'uid': uid,
      'email': email,
      'dateCreated': DateTime.now(),
      'courses': [],
      'interests': [],
      'studentLevel': 0,
      'avatar':
          'https://firebasestorage.googleapis.com/v0/b/agileproject-76bf9.appspot.com/o/User%20Data%2Fuser.png?alt=media&token=0b4c347c-e8d9-456c-b76a-b02f2e4080a0'
    });
  }

  getUsers(UserNotifier userNotifier) async {
    FirebaseFirestore rootRef = FirebaseFirestore.instance;
    rootRef.settings = const Settings(persistenceEnabled: true);
    rootRef.snapshotsInSync();
    QuerySnapshot snapshot = await rootRef.collection('Users').get();

    List<student.UserModel> _users = [];

    for (var document in snapshot.docs) {
      //final data = document as Map<String, dynamic>;
      student.UserModel user =
          student.UserModel.fromMap(document.data() as Map<String, dynamic>);
      _users.add(user);
    }
    if (snapshot.metadata.isFromCache) {
      print('YES! YES! I AM FROM CACHE');
    }
    userNotifier.usersList = _users;
  }

  getCourses(CourseNotifier courseNotifier) async {
    FirebaseFirestore rootRef = FirebaseFirestore.instance;
    rootRef.settings = const Settings(persistenceEnabled: true);
    rootRef.snapshotsInSync();
    QuerySnapshot snapshot = await rootRef.collection('Courses').get();

    RxList<Course> _courses = RxList();

    for (var document in snapshot.docs) {
      //final data = document as Map<String, dynamic>;
      Course course = Course.fromMap(document.data() as Map<String, dynamic>);
      _courses.add(course);
    }
    if (snapshot.metadata.isFromCache) {
      print('YES! YES! I AM FROM CACHE');
    }
    courseNotifier.courseList = _courses;
  }

  getSavedCourses(SavedCoursesNotifier savedCourses, String docId) async {
    FirebaseFirestore rootRef = FirebaseFirestore.instance;
    rootRef.settings = const Settings(persistenceEnabled: true);
    rootRef.snapshotsInSync();
    QuerySnapshot snapshot = await rootRef
        .collection('Users')
        .doc(docId)
        .collection('Favourites')
        .get();

    //.orderBy('savedAt', descending: true).

    List<Course> _savedCourses = [];

    for (var document in snapshot.docs) {
      //final data = document as Map<String, dynamic>;
      Course course = Course.fromMap(document.data() as Map<String, dynamic>);
      if (!_savedCourses.contains(course)) {
        _savedCourses.add(course);
      }
    }
    if (snapshot.metadata.isFromCache) {
      print('YES! YES! I AM FROM CACHE');
    }
    savedCourses.savedCourses = _savedCourses;
  }

  Future<String?> addSavedCourseSubCollection(
      {required SavedCoursesNotifier savedCourses,
      required CourseNotifier courseNotifier,
      required List displayList,
      required int index,
      required duplicateCount}) async {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');

    var myUser = await FirebaseFirestore.instance
        .collection('Users')
        .where('uid', isEqualTo: user?.uid)
        .get();
    if (myUser.docs.isNotEmpty) {
      var docId = myUser.docs.first.id;

      for (int i = 0; i < savedCourses.savedCourses.length;) {
        if (courseNotifier.currentCourse.courseName ==
            savedCourses.savedCourses[i].courseName) {
          duplicateCount++;
          i++;
        } else {
          i++;
        }
      }
      if (duplicateCount < 1) {
        await users.doc(docId).collection('Favourites').add({
          'courseName': displayList[index].courseName,
          'courseId': displayList[index].courseId,
          'subjectArea': displayList[index].subjectArea,
          'courseImage': displayList[index].media[1],
          'level': displayList[index].level,
          'duration': displayList[index].duration,
          'hoursPerWeek': displayList[index].hoursPerWeek,
          'isSaved': displayList[index].isSaved,
          'prereqs': displayList[index].prereqs,
          'media': displayList[index].media,
          'savedAt': FieldValue.serverTimestamp(),
        });
        // add the course to savedCourses
        savedCourses.add(courseNotifier.currentCourse);
      } else {
        print('duplicate');
      }
      return null;
    }
    return null;
  }

  Future<void> removeSavedCourseSubCollection({
    required SavedCoursesNotifier savedCourses,
    required CourseNotifier courseNotifier,
    required String courseName,
  }) async {
    late final DocumentReference<Map<String, dynamic>> userRef;

    var myUser = await FirebaseFirestore.instance
        .collection('Users')
        .where('uid', isEqualTo: user?.uid)
        .get();
    if (myUser.docs.isNotEmpty) {
      var docId = myUser.docs.first.id;

      userRef = FirebaseFirestore.instance.collection('Users').doc(docId);
      final favsRef = userRef.collection('Favourites');

      final snapshot =
          await favsRef.where('courseName', isEqualTo: courseName).get();
      if (snapshot.docs.isNotEmpty) {
        final documentId = snapshot.docs.first.id;
        await favsRef
            .doc(documentId)
            .delete()
            .then((value) => print('deleted'));
        print('doc id: $documentId');
      } else {
        throw Exception('Document not found');
      }
      savedCourses.savedCourses.removeWhere(
        (course) =>
            course.courseName == courseNotifier.currentCourse.courseName,
      );
    }
  }

  Future test() async {
    return Future.delayed(const Duration(seconds: 1));
  }

  bool checkConflicts(List<Lesson> allLessonsList, List<Lesson> userLessonsList,
      Course currentCourse) {
    List<Lesson> currentLessons = [];
    for (var lesson in allLessonsList) {
      if (lesson.courseId == currentCourse.courseId) {
        currentLessons.add(lesson);
      }
    }
    for (var lesson in currentLessons) {
      print('current lessons: ${lesson.lessonName}');
    }

    for (var userLesson in userLessonsList) {
      print(
          'User Lesson Name: ${userLesson.lessonName} and ${userLesson.courseId} and time: ${userLesson.startTime!.toDate()}');
      for (var currentLesson in currentLessons) {
        print(
            "Current Lesson name: ${currentLesson.lessonName} and id: ${currentLesson.courseId} and time:${currentLesson.startTime!.toDate()} ");
        if ((userLesson.startTime!.toDate().isBefore(currentLesson.endTime!.toDate()) &&
            userLesson.endTime!.toDate().isAfter(currentLesson.startTime!.toDate()))) {
          return true;
        }
      }
    }
    // for (var userLesson in userLessonsList) {
    //   if (currentLessons.any((cl) {
    //     cl.startTime == userLesson.startTime;
    //     return
    //   }
    //       )) {
    //     return true;
    //   }
    // }
    return false;
  }

  Future<void> updateUserCourses(UserNotifier userNotifier,
      CourseNotifier courseNotifier, LessonNotifier lessonNotifier) async {
      var myUser = await FirebaseFirestore.instance
          .collection("Users")
          .where("uid", isEqualTo: user?.uid)
          .get();
      if (myUser.docs.isNotEmpty) {
        var docId = myUser.docs.first.id;

        var ids = userNotifier.getCourseIds();


        var allLessonsList =
            await getAllLessons(ids, lessonNotifier, userNotifier);
        var userLessonsList =
            await getUserLessons(ids, lessonNotifier, userNotifier);

        print(allLessonsList);
        print(userLessonsList);

        int totalWeeklyHours = getTotalWeeklyHours(ids, courseNotifier);

        if (checkConflicts(
            allLessonsList, userLessonsList, courseNotifier.currentCourse)) {
          print(
              'checkConflicts decision: ${checkConflicts(allLessonsList, userLessonsList, courseNotifier.currentCourse)}');
          // ids.remove(courseNotifier.currentCourse.courseId);
          userNotifier.isConflict = true;

          print('_userNotifier.isConflict: ${userNotifier.isConflict}');
          throw Exception("Course conflicts with enrolled lessons.");
        } else if (totalWeeklyHours +
                courseNotifier.currentCourse.hoursPerWeek >
            19) {
          print("Weekly Hours Check Ran");
          courseNotifier.isHourlyLimitReached = true;
          throw Exception(
              "Total weekly hours exceed 20. Please complete some courses before adding more.");
        } else {
          print("Else statement Ran");
          DocumentReference docRef =
              FirebaseFirestore.instance.collection("Users").doc(docId);
          print(docId);
          ids.add(courseNotifier.currentCourse.courseId);
          userNotifier.userCourseIds = ids;
          await docRef.update({"courses": ids});
          print('total user courses: $ids');
        }

    }
  }

  int getTotalWeeklyHours(List courseIds, CourseNotifier courseNotifier) {
    int total = 0;
    for (String courseId in courseIds) {
      Course course = getCourseById(
          courseId, courseNotifier); // Retrieve the course based on the id
      total += course.hoursPerWeek; // Add the weekly hours to the total
    }
    return total;
  }

  Course getCourseById(String courseId, CourseNotifier courseNotifier) {
    var res;
    for (var course in courseNotifier.courseList) {
      if (course.courseId.contains(courseId)) {
        res = course;
      }
    }
    return res;
  }

  Future<void> updateUserInterests(
      UserNotifier userNotifier, List updatedList) async {
    print('received updatedList: $updatedList');
    try {
      var myUser = await FirebaseFirestore.instance
          .collection("Users")
          .where("uid", isEqualTo: user?.uid)
          .get();
      if (myUser.docs.isNotEmpty) {
        var docId = myUser.docs.first.id;

        DocumentReference docRef =
            FirebaseFirestore.instance.collection("Users").doc(docId);
        await docRef.update({"interests": updatedList}).whenComplete(() {
          userNotifier.getInterests();
          userNotifier.userInterests = updatedList;
          print('updated firebase and user, complete');
        });

        for (var c in updatedList) {
          print('updated subjects: $c');
        }
        // getUsers(userNotifier);
      }
    } catch (e) {
      print("Error updating user interests: $e");
    }
  }

  Future<void> updateStudentLevel(
      UserNotifier userNotifier, int studentLevel) async {
    try {
      var myUser = await FirebaseFirestore.instance
          .collection("Users")
          .where("uid", isEqualTo: user?.uid)
          .get();
      if (myUser.docs.isNotEmpty) {
        var docId = myUser.docs.first.id;

        // int level = userNotifier.studentLevel;

        int level = studentLevel;

        DocumentReference docRef =
            FirebaseFirestore.instance.collection("Users").doc(docId);
        await docRef.update({"studentLevel": level});
        userNotifier.studentLevel = studentLevel;
        print('current student levels: $level');
      }
    } catch (e) {
      print("Error updating student level: $e");
    }
  }

  /// Calculates number of weeks for a given year as per https://en.wikipedia.org/wiki/ISO_week_date#Weeks_per_year
  int numOfWeeks(int year) {
    DateTime dec28 = DateTime(year, 12, 28);
    int dayOfDec28 = int.parse(DateFormat("D").format(dec28));
    return ((dayOfDec28 - dec28.weekday + 10) / 7).floor();
  }

  /// Calculates week number from a date as per https://en.wikipedia.org/wiki/ISO_week_date#Calculation
  int weekNumber(DateTime date) {
    int dayOfYear = int.parse(DateFormat("D").format(date));
    int woy = ((dayOfYear - date.weekday + 10) / 7).floor();
    if (woy < 1) {
      woy = numOfWeeks(date.year - 1);
    } else if (woy > numOfWeeks(date.year)) {
      woy = 1;
    }
    return woy;
  }

  Future<void> updateLessonDates(List courseIds) async {
    final coursesRef = FirebaseFirestore.instance.collection('Courses');

    final now = DateTime.now();
    final currentWeek = weekNumber(now);

    for (final courseId in courseIds) {
      final courseRef = coursesRef.doc(courseId);
      final lessonsRef = courseRef.collection('Lessons');

      await lessonsRef.get().then((querySnapshot) {
        for (var lessonDoc in querySnapshot.docs) {
          final startDate =
              (lessonDoc.data()['startTime'] as Timestamp).toDate();
          print(startDate);
          if (startDate.isBefore(now)) {
            final elapsedWeeks = currentWeek - weekNumber(startDate);
            final newStartDate =
                startDate.add(Duration(days: elapsedWeeks * 7));
            final newEndDate = (lessonDoc.data()['endTime'] as Timestamp)
                .toDate()
                .add(Duration(days: elapsedWeeks * 7));

            lessonsRef
                .doc(lessonDoc.id)
                .update({
                  'startTime': newStartDate,
                  'endTime': newEndDate,
                })
                .then((value) => print('Lesson updated successfully'))
                .catchError(
                    (error) => print('Failed to update lesson: $error'));
          }
        }
      });
    }
  }

  Future<List<Lesson>> getAllLessons(List userCourses,
      LessonNotifier lessonNotifier, UserNotifier userNotifier) async {
    final courseCollection = FirebaseFirestore.instance.collection('Courses');
    List<Lesson> _lessons = [];
    await updateLessonDates(userNotifier.userCourseIds);

    final coursesSnapshot = await courseCollection.get();

    for (final courseDoc in coursesSnapshot.docs) {
      final courseLessonsRef = courseDoc.reference.collection('Lessons');
      final snapshot = await courseLessonsRef.get();

      for (var document in snapshot.docs) {
        //final data = document as Map<String, dynamic>;
        Lesson lesson = Lesson.fromMap(document.data());
     //  print("Added lesson ${lesson.lessonName} and ${lesson.courseId}");
        _lessons.add(lesson);
      }
      lessonNotifier.allLessonsList = _lessons;
    }

    return _lessons;
    // print(lessonNotifier.lessonsList);
  }

  Future<List<Lesson>> getUserLessons(List userCourses,
      LessonNotifier lessonNotifier, UserNotifier userNotifier) async {
    final courseCollection = FirebaseFirestore.instance.collection('Courses');
    List<Lesson> _lessons = [];
    await updateLessonDates(userNotifier.userCourseIds);

    final coursesQuery =
        courseCollection.where('courseId', whereIn: userCourses);
    final coursesSnapshot = await coursesQuery.get();

    for (final courseDoc in coursesSnapshot.docs) {
      final courseLessonsRef = courseDoc.reference.collection('Lessons');
      final snapshot = await courseLessonsRef.get();

      for (var document in snapshot.docs) {
        //final data = document as Map<String, dynamic>;
        Lesson lesson = Lesson.fromMap(document.data());
        //print(lesson.lessonName);
        _lessons.add(lesson);
      }
      lessonNotifier.userLessonsList = _lessons;
    }

    return _lessons;
    // print(lessonNotifier.lessonsList);
  }


  getClassmates(String courseId, UserNotifier userNotifier) async {
    List<student.UserModel> _users = [];
    var querySnapshot = await FirebaseFirestore.instance
        .collection("Users")
        .where("courses", arrayContains: courseId)
        .get();

    // Loop through the documents to access each user's data
    for (var doc in querySnapshot.docs) {
      // Access user data using doc.data()
      var userData = doc.data();
      student.UserModel user = student.UserModel.fromMap(userData);
      _users.add(user);
      userNotifier.userClassmates = _users;
      // print(user.email);
    }
    return _users;
  }

  getTotalLessons(CourseNotifier courseNotifier) async {
    int numLessons = 0;
    try {
      var course = await FirebaseFirestore.instance
          .collection("Courses")
          .where("courseId", isEqualTo: courseNotifier.currentCourse.courseId)
          .get();
      if (course.docs.isNotEmpty) {
        var docId = course.docs.first.id;

        final courseDoc =
            FirebaseFirestore.instance.collection('Courses').doc(docId);
        final courseLessonsRef = courseDoc.collection('Lessons');

        // Get the total number of lessons for the course
        final totalLessons = (await courseLessonsRef.get()).docs.length;
        numLessons = totalLessons;
        courseNotifier.totalLessons = totalLessons;

        // Update the course document to include the total number of lessons
        await courseDoc.update({
          'totalLessons': totalLessons,
        });
      }
    } catch (e) {
      print(e);
    }
    print('total num of lessons is: ${courseNotifier.totalLessons}');
    return numLessons;
  }
}
