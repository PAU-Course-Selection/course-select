import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IOSLimitationDialog extends StatelessWidget {
  final String message;
  const IOSLimitationDialog({
    Key? key,
    required this.preReqs, required this.message,
  }) : super(key: key);

  final String preReqs;

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text('Enrolment Regulation'),
      content: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(children: [
             TextSpan(
                text: message,
                style: const TextStyle(color: Colors.black)),
            TextSpan(
                text: preReqs,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black))
          ]),
        ),
      ),
      actions: [
        CupertinoDialogAction(
          /// This parameter indicates this action is the default,
          /// and turns the action's text to bold text.
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Okay'),
        ),
      ],
    );
  }
}