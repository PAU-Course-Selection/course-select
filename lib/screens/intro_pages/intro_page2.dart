import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// [IntroPage2] Shows the second welcome page in the slide show
class IntroPage2 extends StatelessWidget {
  const IntroPage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Get Recommendations', style: TextStyle(fontFamily: 'Lato', fontWeight: FontWeight.bold, fontSize: 32),),
            Lottie.asset('assets/animations/course.json'),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text('We help you decide'
                  ' which courses to study, to best suit your learning journey. '
                  'Your own personal guidance counsellor. Grand, fab :)  ', textAlign: TextAlign.center,),
            ),
          ],
        ),
      ),
      color: Colors.white,
    );
  }
}