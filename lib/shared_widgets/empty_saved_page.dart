import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../constants/constants.dart';
import '../screens/search_sheet.dart';
import 'gradient_button.dart';

class Empty extends StatefulWidget {
  final Function onAdd;
  const Empty({Key? key, required this.onAdd}) : super(key: key);

  @override
  State<Empty> createState() => _EmptyState();
}

class _EmptyState extends State<Empty> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(25.0,),
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: kLightBackground.withOpacity(0.2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const ImageIcon(AssetImage('assets/icons/bookmark.png'), color: Color(0xffE49393),),
                const SizedBox(height: 10,),
                Text('Create a shortlist', style: kHeadlineMedium.copyWith(fontSize: 16),),
                const SizedBox(height: 5,),
                SizedBox(
                    width: 200.w,
                    child: const Text('Make it easier with less options to choose from',textAlign: TextAlign.center,))
              ],
            ),

            width: double.infinity,),
        ),
        Flexible(child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: GradientButton(buttonText: 'Add Courses', onPressed: (){
            showCupertinoModalBottomSheet(
              duration: const Duration(milliseconds: 100),
              topRadius: const Radius.circular(20) ,
              barrierColor: Colors.black54,
              elevation: 8,
              context: context,
              builder: (context) => const Material(child: SearchSheet(filter: 'all',)),
            ).whenComplete(() => widget.onAdd.call());
          },),
        ))
      ],
    );
  }
}