import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
class IntroPage3 extends StatelessWidget {
  const IntroPage3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Timetabling', style: TextStyle(fontFamily: 'Lato', fontWeight: FontWeight.bold, fontSize: 32),),
            Lottie.asset('assets/animations/timetable2.json'),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text('As if that is not enough, a beautiful calendar to keep track and organise all lessons ', textAlign: TextAlign.center,),
            ),
          ],
        ),
      ),
      color: Colors.white,
    );
  }
}
