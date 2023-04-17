import 'package:course_select/constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AndroidLimitationDialog extends StatelessWidget {
  const AndroidLimitationDialog({
    Key? key,
    required this.preReqs,
  }) : super(key: key);

  final String preReqs;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: const Text('Enrolment Regulation'),
      content: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(children: [
            const TextSpan(
                text: 'Based on your skill level and this course\'s prerequisite requirements, '
                    'we recommend that you take ',
                style: TextStyle(color: Colors.black)),
            TextSpan(
                text: preReqs,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black))
          ]),
        ),
      ),
      actions: [
        TextButton(
          style: ButtonStyle(overlayColor: MaterialStatePropertyAll(kSaraLightPink)),
          onPressed: () {
            Navigator.pop(context);
          },
          child:  Text('Okay', style: TextStyle(color: kDeepGreen),),
        ),
      ],
    );
  }
}