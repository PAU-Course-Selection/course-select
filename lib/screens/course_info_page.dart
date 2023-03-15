import 'package:course_select/controllers/course_notifier.dart';
import 'package:course_select/screens/course_info.dart';
import 'package:course_select/utils/firebase_data_management.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CourseInfoPage extends StatefulWidget {
  const CourseInfoPage({Key? key}) : super(key: key);

  @override
  State<CourseInfoPage> createState() => _CourseInfoPageState();
}

class _CourseInfoPageState extends State<CourseInfoPage> {
  late final CourseNotifier _courseNotifier;

  final DatabaseManager _db = DatabaseManager();

  @override
  void initState() {
    _courseNotifier = Provider.of<CourseNotifier>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(_courseNotifier.currentCourse.courseName),
      ),
      body: CourseInfo(
        courseImage: _courseNotifier.currentCourse.media[1],
        courseTitle: _courseNotifier.currentCourse.courseName,
        //courseLessons: _courseNotifier.currentCourse.numOfLessons,
        weeks: _courseNotifier.currentCourse.duration,
        weeklyHours: _courseNotifier.currentCourse.hoursPerWeek,
      ),
    );
  }
}
