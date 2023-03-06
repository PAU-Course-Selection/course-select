import 'package:course_select/routes/routes.dart';
import 'package:course_select/shared_widgets/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/user_controller.dart';
import 'auth.dart';

class UserProfilePage extends StatelessWidget {
  UserProfilePage({Key? key}) : super(key: key);

  final User? user = Auth().currentUser;
  final userController = Get.put(UserController());

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _title() {
    return const Text('Edit Profile');
  }

  Widget _userUid() {
    return Text(user?.email ?? 'User email');
  }

  Widget _signOutButton() {
    return ElevatedButton(
      onPressed: () => {
        signOut(),
        Get.offAndToNamed(PageRoutes.loginRegister)},
      child: const Text('Sign Out'),
    );
  }

  String _userName() {
    for(var student in userController.usersList){
      if (student.email == user?.email){
        return student.displayName?? '';
      }
    }
    return '';
  }

  Widget _date() {
    for(var student in userController.usersList){
      if (student.email == user?.email){
        DateTime? date = student.dateCreated?.toDate();
        return Text(date.toString());
      }
    }
    return const Text('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
        backgroundColor: kPrimaryColour,
        foregroundColor: Colors.black,
        actions:const [Padding(
          padding: EdgeInsets.only(right: 15.0),
          child: Icon(Icons.edit),
        )],
      ),
      body: Container(
        height: 160,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child:Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: photo(),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  Text(_userName()),
                  _date(),
                  _userUid(),
                  _signOutButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class photo extends StatelessWidget {
  const photo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(PageRoutes.userProfile),
      child: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: SizedBox(
              child: ClipOval(
                child: Image.asset(
                  "assets/images/avatar.jpg",
                ),
              ))),
    );
  }
}
