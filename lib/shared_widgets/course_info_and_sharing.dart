import 'package:course_select/constants/constants.dart';
import 'package:course_select/controllers/course_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class MiniCourseInfoAndShare extends StatefulWidget {
  const MiniCourseInfoAndShare({Key? key}) : super(key: key);

  @override
  State<MiniCourseInfoAndShare> createState() => _MiniCourseInfoAndShareState();
}

class _MiniCourseInfoAndShareState extends State<MiniCourseInfoAndShare> {
  late CourseNotifier _courseNotifier;

  @override
  void initState() {
    _courseNotifier = Provider.of<CourseNotifier>(context, listen: false);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            4.0,
            4.0,
            4.0,
            4.0,
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
                boxShadow: kSomeShadow,
                color: kLightGreen,
                borderRadius: const BorderRadius.all(Radius.circular(32.0))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 4.0),
                  child: Icon(Icons.book),
                ),
                Text("22 Lessons"),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            boxShadow: kSomeShadow,
            color: kLightGreen,
            borderRadius: const BorderRadius.all(
              Radius.circular(32.0),
            ),
          ),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 4.0),
                child: Icon(Icons.timelapse),
              ),
              Text(_hoursPerWeek()),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: () =>
              Share.share(
                  "Check out the ${_courseNotifier.currentCourse
                      .courseName} course in the Study Sprint app."),
          child: const Icon(Icons.share),
          style: ButtonStyle(
              padding: const MaterialStatePropertyAll<EdgeInsetsGeometry>(
                  EdgeInsets.all(16.0)),
              shape: const MaterialStatePropertyAll<OutlinedBorder>(
                  CircleBorder()),
              backgroundColor: MaterialStatePropertyAll<Color>(kPrimaryColour),
              foregroundColor:
              const MaterialStatePropertyAll<Color>(Colors.black),
              elevation: MaterialStateProperty.all(8.0)),
        ),
      ],
    );
  }

  String _hoursPerWeek() {
    String hpw = _courseNotifier.currentCourse.hoursPerWeek.toString();

    return "$hpw Weeks ";
  }
}
