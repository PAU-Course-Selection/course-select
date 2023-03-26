import 'package:course_select/controllers/course_notifier.dart';
import 'package:course_select/models/course_data_model.dart';
import 'package:course_select/models/user_data_model.dart' as student;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../controllers/user_notifier.dart';
import '../models/saved_course_data_model.dart';
import 'auth.dart';

class DatabaseManager {
  final data = FirebaseFirestore.instance;

  late final UserNotifier userNotifier;
  final User? user = Auth().currentUser;
  //late String myDocId;
  late final DocumentReference<Map<String, dynamic>> userRef;
  late Query<Map<String, dynamic>> favoritesQuery = FirebaseFirestore.instance
      .collection('Dummy')
      .where('dummyField', isEqualTo: 'dummyValue');

  Future<void> userSetup(
      {required String displayName, required String email}) async {
    CollectionReference users = data.collection('Users');
    FirebaseAuth auth = FirebaseAuth.instance;
    String? uid = auth.currentUser?.uid.toString();
    users.add(
        {
          'displayName': displayName,
          'uid': uid,
          'email': email,
          'dateCreated': DateTime.now(),
          'avatar': 'https://firebasestorage.googleapis.com/v0/b/agileproject-76bf9.appspot.com/o/User%20Data%2Fuser.png?alt=media&token=0b4c347c-e8d9-456c-b76a-b02f2e4080a0'
        }).then((DocumentReference doc) => print(doc.id));
  }

  getUsers(UserNotifier userNotifier) async {
    FirebaseFirestore rootRef = FirebaseFirestore.instance;
    rootRef.settings = const Settings(persistenceEnabled: true);
    rootRef.snapshotsInSync();
    QuerySnapshot snapshot = await rootRef.collection('Users').get();

    List<student.UserModel> _users = [];

    for (var document in snapshot.docs) {
      //final data = document as Map<String, dynamic>;
      student.UserModel user = student.UserModel.fromMap(
          document.data() as Map<String, dynamic>);
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

  getSavedCourses(SavedCourses savedCourses, String docId) async {
    FirebaseFirestore rootRef = FirebaseFirestore.instance;
    rootRef.settings = const Settings(persistenceEnabled: true);
    rootRef.snapshotsInSync();
    QuerySnapshot snapshot = await rootRef.collection('Users')
        .doc(docId).collection('Favourites').orderBy('savedAt', descending: true).get();

      List<Course> _savedCourses = [];

      for (var document in snapshot.docs) {
        //final data = document as Map<String, dynamic>;
        Course course = Course.fromMap(document.data() as Map<String, dynamic>);
        if(!_savedCourses.contains(course)){
          _savedCourses.add(course);
        }
      }
      if (snapshot.metadata.isFromCache) {
        print('YES! YES! I AM FROM CACHE');
      }
      savedCourses.savedCourses = _savedCourses;
  }
}
