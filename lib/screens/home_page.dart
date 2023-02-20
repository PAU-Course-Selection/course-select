import 'package:course_select/controllers/course_controller.dart';
import 'package:course_select/controllers/user_controller.dart';
import 'package:course_select/routes/routes.dart';
import 'package:course_select/utils/firebase_data_management.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User? user = Auth().currentUser;
  DatabaseManager db = DatabaseManager();
  final userController = Get.put(UserController());
  final courseController = Get.put(CourseController());

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _title() {
    return const Text('Home');
  }

  Widget _userUid() {
    return Text(user?.email ?? 'User email');
  }
  Widget _userName() {
    return Text(user?.displayName ?? 'name');
  }

  Widget _signOutButton() {
    return ElevatedButton(
      onPressed: () => {
        signOut(),
        Get.offAndToNamed(PageRoutes.loginRegister)},
      child: const Text('Sign Out'),
    );
  }

  Future getModels(){
    return db.getCourses(courseController);
  }

  @override
  void initState() {
    super.initState();
    getModels();
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: _title(),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder(
        future: getModels(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          /// The snapshot data type have to be same of the result of your web service method
          if (snapshot.connectionState == ConnectionState.done) {
            /// When the result of the future call respond and has data show that data
            return Container(
              height: double.infinity,
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 200,
                    width: 300,
                    child: ListView.builder(
                        itemCount: courseController.courseList.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              leading: const Icon(Icons.library_books),
                              title: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Text(courseController.courseList[index].courseName,),
                              ),
                              subtitle: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Course ID: ' + courseController.courseList[index].courseId,),
                                  Text('Subject Area: ' + courseController.courseList[index].subjectArea,),
                                  Text('Skill level: ' + courseController.courseList[index].level,),
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                  Text('Hi ' + userController.userName.string),
                  _userUid(),
                  _signOutButton(),
                ],
              ),
            );
          }else if(snapshot.hasError) {
            return Container(child: Center(child: Text('Oops...something happened',style: TextStyle(color: Colors.black),),));
          }
          /// While is no data show this
          return const Center(child: Text('No data'));
        }),
    );
  }
}