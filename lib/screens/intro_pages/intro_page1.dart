import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
class IntroPage1 extends StatelessWidget {
  const IntroPage1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Select Courses', style: TextStyle(fontFamily: 'Lato', fontWeight: FontWeight.bold, fontSize: 32),),
            Lottie.asset('assets/animations/online-learning.json'),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text('Pursuing a career in tech, but not sure where to start? Maybe baby python '
                  'is not enough to get that sweet software developer salary your aunt Rose keeps talking about? Sift through a wide range of tech courses available ', textAlign: TextAlign.center,),
            ),
          ],
        ),
      ),
      color: Colors.white,
    );
  }
}