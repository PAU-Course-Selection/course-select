import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

import '../../constants/constants.dart';

/// [OngoingCourseTile] formats an active course item in the ongoing course list on the courses page
/// This view shows the course progress
class OngoingCourseTile extends StatelessWidget {
  final String courseName;
  final String courseImage;
  final int remainingLessons;
  const OngoingCourseTile({
    Key? key,
    required this.valueNotifier, required this.courseName, required this.courseImage, required this.remainingLessons,
  }) : super(key: key);

  final ValueNotifier<double> valueNotifier;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0, ),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color:  kLightBackground.withOpacity(0.2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                      image: AssetImage(courseImage))),
              height: 70.h,
              width: 70.w,
            ),
            SizedBox(
              width: 210.w,
              child: Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:  [
                    Flexible(
                        child: Text(courseName, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18,),maxLines: 2)),
                    const SizedBox(
                      height: 5,
                    ),
                    Text('$remainingLessons lessons left', style: const TextStyle(color: Colors.grey),)
                  ],
                ),
              ),
            ),
            Flexible(
              child: SimpleCircularProgressBar(
                animationDuration: 1,
                backColor: const Color(0xffD9D9D9),
                progressColors: [kSelected,kPrimaryColour],
                progressStrokeWidth: 8,
                backStrokeWidth: 8,
                size: 50,
                valueNotifier: valueNotifier,
                mergeMode: true,
                onGetText: (double value) {
                  return Text('${value.toInt()}%');
                },
              ),
            ),
          ],
        ),
        width: double.infinity,),
    );
  }
}