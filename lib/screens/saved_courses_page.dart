import 'package:course_select/screens/search_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../constants/constants.dart';
import '../shared_widgets/gradient_button.dart';

class SavedCourses extends StatelessWidget {
  const SavedCourses({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Shortlist', style: kHeadlineMedium,),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(
              25.0,
            ),
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: kLightBackground.withOpacity(0.2),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ImageIcon(
                    const AssetImage('assets/icons/bookmark.png'),
                    color: kSaraAccent,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Create a shortlist',
                    style: kHeadlineMedium.copyWith(fontSize: 16),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                      width: 200.w,
                      child: const Text(
                        'Make it easier with less options to choose from',
                        textAlign: TextAlign.center,
                      ))
                ],
              ),
              width: double.infinity,
            ),
          ),
          Flexible(
              child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: GradientButton(
              buttonText: 'Add Courses',
              onPressed: () {
                showCupertinoModalBottomSheet(
                  duration: const Duration(milliseconds: 100),
                  topRadius: const Radius.circular(20),
                  barrierColor: Colors.black54,
                  elevation: 8,
                  context: context,
                  builder: (context) => const Material(
                      child: SearchSheet(
                    filter: 'all',
                  )),
                );
              },
            ),
          ))
        ],
      ),
    );
  }
}
