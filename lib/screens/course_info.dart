import 'package:flutter/material.dart';

class CourseInfo extends StatefulWidget {
  final String courseTitle;
  final String courseImage;
  //final int courseLessons;
  final int weeks;
  final int weeklyHours;

  const CourseInfo({
    Key? key,
    required this.courseImage,
    required this.courseTitle,
  //  required this.courseLessons,
    required this.weeks,
    required this.weeklyHours,
  }) : super(key: key);

  @override
  State<CourseInfo> createState() => _CourseInfoState();
}

class _CourseInfoState extends State<CourseInfo> {
  @override
  Widget build(BuildContext context) {
    return _courseInfo();
  }

  Widget _courseInfo() {
    Column infoPage = Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(widget.courseTitle),
        Image(
          image: AssetImage(widget.courseImage),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              child: Row(
                children: [Icon(Icons.abc),
                Text(""),],
              ),
            ),
            Container(),
            Container(),
          ],
        )
      ],
    );

    return infoPage;
  }
}
