import 'package:course_select/controllers/course_controller.dart';
import 'package:course_select/models/course_data_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseManager{
  final data  = FirebaseFirestore.instance ;

  Future<void> userSetup({required String displayName, required String email}) async {
    CollectionReference users = data.collection('Users');
    FirebaseAuth auth = FirebaseAuth.instance;
    String? uid = auth.currentUser?.uid.toString();
    users.add(
        {
          'displayName': displayName,
          'uid': uid,
          'email': email
        });
  }

  getCourses(CourseController courseController) async {
    FirebaseFirestore rootRef = FirebaseFirestore.instance;
    rootRef.settings = const Settings(persistenceEnabled: true);
    rootRef.snapshotsInSync();
    QuerySnapshot snapshot = await rootRef.collection('Courses').get();

    List<Course> _courses = [];

    for (var document in snapshot.docs) {
      //final data = document as Map<String, dynamic>;
      Course course = Course.fromMap(document.data() as Map<String, dynamic>) ;
      _courses.add(course);
    }
    if (snapshot.metadata.isFromCache) {
      print('YES! YES! I AM FROM CACHE');
    }
    courseController.courseList = _courses;
  }


}
