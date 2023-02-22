import 'package:course_select/routes/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

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
    return const Text('User Profile');
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
        DateTime date = student.dateCreated.toDate();
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
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(_userName()),
            _date(),
            _userUid(),
            _signOutButton(),
          ],
        ),
      ),
    );
  }
}