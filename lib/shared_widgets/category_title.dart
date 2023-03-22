import 'package:flutter/material.dart';
import '../constants/constants.dart';

class CategoryTitle extends StatelessWidget {
  final String text;
  final Function onPressed;
  const CategoryTitle({
    Key? key, required this.text, required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.only(top: 30, bottom: 20,left: 25),
          child: Text(
            text,
            style: kHeadlineMedium,
          ),
        ),
        Flexible(
          child: TextButton(
            style: TextButton.styleFrom(minimumSize: Size.zero, padding: EdgeInsets.zero,  tapTargetSize: MaterialTapTargetSize.shrinkWrap,),
              onPressed: ()=> onPressed.call(),
              child:  Padding(
            padding: const EdgeInsets.only(right: 25.0),
            child: Text('View all', style: TextStyle(fontSize: 18, fontFamily: 'Roboto', color: kPrimaryColour),),
          )),
        )
      ],
    );
  }
}