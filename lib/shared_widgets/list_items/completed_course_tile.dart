import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constants/constants.dart';

/// [CompletedCourseTile] formats the list items for completed courses on the courses page
class CompletedCourseTile extends StatelessWidget {
  final String courseName;
  final String courseImage;
  final int remainingLessons;
  const CompletedCourseTile({
    Key? key, required this.courseName, required this.courseImage, required this.remainingLessons,
  }) : super(key: key);

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
             const Flexible(
              child: ImageIcon(AssetImage('assets/icons/check.png'),color: Colors.green,)
            ),
          ],
        ),
        width: double.infinity,),
    );
  }
}