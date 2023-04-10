import 'package:course_select/controllers/course_notifier.dart';
import 'package:course_select/controllers/lesson_notifier.dart';
import 'package:course_select/models/course_data_model.dart';
import 'package:course_select/models/lesson_data_model.dart';
import 'package:course_select/models/user_data_model.dart' as student;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

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

  Future<void> updateUserCourses(
      UserNotifier userNotifier, CourseNotifier courseNotifier) async {
    List ids = [];
    try {
      var myUser = await FirebaseFirestore.instance
          .collection("Users")
          .where("uid", isEqualTo: user?.uid)
          .get();
      if (myUser.docs.isNotEmpty) {
        var docId = myUser.docs.first.id;

        ids = userNotifier.getCourseIds();

        DocumentReference docRef =
            FirebaseFirestore.instance.collection("Users").doc(docId);
        ids.add(courseNotifier.currentCourse.courseId);
        await docRef.update({"courses": ids});
        print('total user courses: $ids');
        // getUsers(userNotifier);
      }
    } catch (e) {
      print("Error updating user courses: $e");
    }
  }

  Future<void> updateUserInterests(
      UserNotifier userNotifier, List updatedList) async {
    try {
      var myUser = await FirebaseFirestore.instance
          .collection("Users")
          .where("uid", isEqualTo: user?.uid)
          .get();
      if (myUser.docs.isNotEmpty) {
        var docId = myUser.docs.first.id;

        List interests = userNotifier.getInterests();
        for (var interest in updatedList) {
          if (!interests.contains(interest)) {
            interests.add(interest);
          }
        }

        DocumentReference docRef = FirebaseFirestore.instance.collection("Users").doc(docId);
        await docRef.update({"interests": interests});
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

        DocumentReference docRef = FirebaseFirestore.instance.collection("Users").doc(docId);
        await docRef.update({"studentLevel": level});
        userNotifier.studentLevel = studentLevel;
        print('current student levels: $level');
      }
    } catch (e) {
      print("Error updating student level: $e");
    }
  }


  Future<List<Lesson>> getLessons(
      List userCourses, LessonNotifier lessonNotifier) async {
    final courseCollection = FirebaseFirestore.instance.collection('Courses');
    //final snapshots = [];
    List<Lesson> _lessons = [];

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
      lessonNotifier.lessonsList = _lessons;
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
    try{
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
    }catch (e){
      print(e);
    }
    print('total num of lessons is: ${courseNotifier.totalLessons}');
    return numLessons;
  }
}
