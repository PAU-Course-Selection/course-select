import 'package:course_select/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Classmates extends StatefulWidget {
  const Classmates({Key? key}) : super(key: key);

  @override
  State<Classmates> createState() => _ClassmatesState();
}

class _ClassmatesState extends State<Classmates> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Container(
        height: 100.h,
        width: double.infinity,
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: kGreyBackground,
          boxShadow: kSomeShadow,
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            CircleAvatar(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              radius: 30,
              child: ImageIcon(AssetImage("assets/images/female.png")),
            ),
            CircleAvatar(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              radius: 30,
              child: ImageIcon(AssetImage("assets/images/male.png")),
            ),
            CircleAvatar(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              radius: 30,
              child: ImageIcon(AssetImage("assets/images/female.png")),
            ),
            CircleAvatar(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              radius: 30,
              child: ImageIcon(AssetImage("assets/images/male.png")),
            ),
          ],
        ),
      ),
    );
  }
}
