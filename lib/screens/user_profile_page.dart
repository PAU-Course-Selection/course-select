import 'package:cached_network_image/cached_network_image.dart';
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
    return const Text('My Profile');
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
        String? year = date?.year.toString();
        String? month = date?.month.toString();
        String? day = date?.day.toString();
        return Text("Joined on $year-$month-$day");
      }
    }
    return const Text('');
  }

  String _avatar(){
    try {
      for (var student in userController.usersList) {
        if (student.email == user?.email) {
          return student.avatar ?? '';
        }
      }
    }on ArgumentError catch(e) {
      print(e);
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions:const [Padding(
          padding: EdgeInsets.only(right: 15.0),
          child: Icon(Icons.edit),
        )],
      ),
      body: Column(
        children: [
          Container(
            height: 160,
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child:Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                 Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: PhotoAvatar(image: _avatar(),)
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(_userName(),style: const TextStyle(fontWeight: FontWeight.bold),),
                      _userUid(),
                      _date(),
                      _signOutButton(),
                    ],
                  ),
                ),
              ],
            ),

          ),
          //TODO create list tiles for settings and options according to design
          Text("Language"),
          Text("Clear Schedule"),
          Text("Manage Courses"),
          Text("Allow Activity Sharing"),
          Text("Log Out"),
          Text("Delete Account"),
          const Expanded(child: Text("App version 1.0.1", style: TextStyle(color: Colors.grey),))
        ],
      ),
    );
  }
}



class PhotoAvatar extends StatelessWidget {
  final String image;
  const PhotoAvatar({
    Key? key, required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
            radius: 45,
            backgroundColor: Colors.white,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(45),
              child: CachedNetworkImage(
                imageUrl: image,
                placeholder: (context, url){
                  return const CircularProgressIndicator();
                },
                errorWidget: (context, url, error) => const Icon(Icons.person, color: Colors.grey,),
              ),
            )),

        Positioned(
          bottom: 0,
            right: 5,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 15,
                child: Icon(Icons.camera_alt,size: 20, color: kPrimaryColour,)))
      ]
    );
  }
}
