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
      padding: const EdgeInsets.fromLTRB(
        16.0,
        8.0,
        16.0,
        4.0,
      ),
      child: Container(
        height: 100.h,
        width: double.infinity,
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: const Color(0xffE1F0EC),
          borderRadius: BorderRadius.circular(8.0),
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
