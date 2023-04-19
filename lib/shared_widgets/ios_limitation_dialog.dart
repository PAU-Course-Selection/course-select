import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IOSLimitationDialog extends StatefulWidget {
  final String message;
  final VoidCallback onTap;
  const IOSLimitationDialog({
    Key? key,
    required this.preReqs, required this.message, required this.onTap,
  }) : super(key: key);

  final String preReqs;

  @override
  State<IOSLimitationDialog> createState() => _IOSLimitationDialogState();
}

class _IOSLimitationDialogState extends State<IOSLimitationDialog> {
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
                text: widget.message,
                style: const TextStyle(color: Colors.black)),
            TextSpan(
                text: widget.preReqs,
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
            widget.onTap.call();
          },
          child: const Text('Okay'),
        ),
      ],
    );
  }
}