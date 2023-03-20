import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';

class CategoryTitle extends StatelessWidget {
  final String text;
  const CategoryTitle({
    Key? key, required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.only(top: 30, bottom: 20,left: 25),
          child: Text(
            text,
            style: kHeadlineMedium,
          ),
        ),
        TextButton(onPressed: (){}, child:  Padding(
          padding: const EdgeInsets.only(right: 25.0),
          child: Text('View all', style: TextStyle(fontSize: 18, fontFamily: 'Roboto', color: kPrimaryColour),),
        ))
      ],
    );
  }
}