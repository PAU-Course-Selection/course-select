import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'constants.dart';

class CourseCard extends StatelessWidget {
  final String courseTitle;
  final String courseImage;
  const CourseCard({Key? key, required this.courseTitle, required this.courseImage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
          color: Color(0xffa7fcd1),
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
                color: Color.fromRGBO(143, 148, 251, .1),
                blurRadius: 10.0,
                offset: Offset(0, 5)
            ),
            BoxShadow(
                color: Color.fromRGBO(143, 148, 251, .05),
                blurRadius: 10.0,
                offset: Offset(0, 5)
            )
          ]
      ),
      padding: EdgeInsets.all(15),
      width: screenWidth * 0.55,
      height: 300.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            child: Image(image: AssetImage(courseImage),fit: BoxFit.contain, ),
          ),
          Container(
            child: Text(courseTitle, style: kHeadlineMedium.copyWith(fontSize: 18),
              maxLines: 2, overflow: TextOverflow.ellipsis,),
          )
        ],
      ),
    );
  }
}
