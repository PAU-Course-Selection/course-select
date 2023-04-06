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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: SizedBox(
        width: double.infinity,
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration:  const BoxDecoration(
                    color: Color(0xffffeeca),
                    borderRadius:
                        BorderRadius.all(Radius.circular(25.0))),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Image.asset('assets/icons/hourglass.png', width: 24, height: 20,)
                    ),
                    const Text("22 Lessons", style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration:  const BoxDecoration(
                  color: Color(0xffd5f1d3),
                  borderRadius: BorderRadius.all(
                    Radius.circular(25.0),
                  ),
                ),
                child: Row(
                  children: [
                     Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Image.asset('assets/icons/lesson.png', width: 24, height: 20,)
                    ),
                    Text(_hoursPerWeek(), style: const TextStyle(fontWeight: FontWeight.bold),),
                  ],
                ),
              ),
            ),const SizedBox(
              width: 10,
            ),
            FloatingActionButton(
              backgroundColor: Color(0xfff4e1fe),
              foregroundColor: kTeal,
              elevation: 0,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onPressed: () => Share.share(
                  "Check out the ${_courseNotifier.currentCourse.courseName} course in the Study Sprint app."),
              child: const Icon(Icons.share),
            ),
          ],
        ),
      ),
    );
  }

  String _hoursPerWeek() {
    String hpw = _courseNotifier.currentCourse.hoursPerWeek.toString();
    return "$hpw Weeks ";
  }
}
