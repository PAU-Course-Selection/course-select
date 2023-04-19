import 'package:course_select/controllers/lesson_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../controllers/course_notifier.dart';
import '../controllers/home_page_notifier.dart';
import '../controllers/user_notifier.dart';
import '../utils/firebase_data_management.dart';

class IOSConfirmationDialog extends StatelessWidget {
  const IOSConfirmationDialog({
    Key? key,
    required CourseNotifier courseNotifier,
    required this.preReqs,
    required DatabaseManager db,
    required UserNotifier userNotifier,
    required HomePageNotifier homePageNotifier,
    required LessonNotifier lessonNotifier,
  }) : _courseNotifier = courseNotifier, _db = db, _userNotifier = userNotifier,  _homePageNotifier = homePageNotifier, _lessonNotifier = lessonNotifier, super(key: key);

  final CourseNotifier _courseNotifier;
  final String preReqs;
  final DatabaseManager _db;
  final UserNotifier _userNotifier;
  final HomePageNotifier _homePageNotifier;
  final LessonNotifier _lessonNotifier;

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text('Confirmation'),
      content: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(children: [
            TextSpan(text: 'Confirm you want to enrol on the course: ${_courseNotifier.currentCourse.courseName} ',
                style: const TextStyle(color: Colors.black)),
            TextSpan(
                text: preReqs,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black))
          ]),
        ),
      ),
      actions: [
        CupertinoDialogAction(
          /// This parameter indicates this action is the default,
          /// and turns the action's text to bold text.
          isDefaultAction: true,
          onPressed: () {
            _db.updateUserCourses(
                _userNotifier, _courseNotifier, _lessonNotifier);
            _homePageNotifier.isStateChanged = true;
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                elevation: 1,
                behavior: SnackBarBehavior.fixed,
                backgroundColor: kKindaGreen,
                shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(5)),
                content: const Center(
                    child: Text(
                      'Enrolment successful',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    )),
                duration: const Duration(seconds: 1),
              ),
            );
          },
          child: const Text('Okay'),
        ),
        CupertinoDialogAction(
          /// This parameter indicates this action is the default,
          /// and turns the action's text to bold text.
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}