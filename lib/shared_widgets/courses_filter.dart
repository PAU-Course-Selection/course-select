import 'package:course_select/shared_widgets/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'category_button.dart';

class CoursesFilter extends StatefulWidget {
  final bool isListView;
  const CoursesFilter({Key? key, required this.isListView}) : super(key: key);

  @override
  State<CoursesFilter> createState() => _CoursesFilterState();
}

class _CoursesFilterState extends State<CoursesFilter> {
  bool b1 = false;
  bool b2 = false;
  bool b3 = false;
  bool b4 = false;


  @override
  Widget build(BuildContext context) {
    List<Widget> cats = [
      Padding(
        padding: const EdgeInsets.only(right: 5.0),
        child: CategoryButton(
          bgColour: b1? kSelected:Colors.white,
          iconBgColour: Colors.blue,
          icon: Icons.school_rounded,
          iconColour: Colors.white,
          text: 'All courses',
          onTap: (){
            setState(() {
              b1 = !b1;
              b2 = false;
              b3 = false;
              b4 = false;
            });
          },
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 5.0),
        child: CategoryButton(
          bgColour: b2? kSelected: Colors.white,
          iconBgColour: Colors.orange,
          icon: Icons.child_care,
          iconColour: Colors.white,
          text: 'Beginner',
          onTap: (){
            setState(() {
              b1 = false;
              b2 = !b2 ;
              b3 = false;
              b4 = false;
            });
          },
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 5.0),
        child: CategoryButton(
          bgColour: b3? kSelected: Colors.white,
          iconBgColour: Colors.pinkAccent,
          icon: Icons.sports_gymnastics,
          iconColour: Colors.white,
          text: 'Intermediate',
          onTap: (){
            setState(() {
              b1 = false;
              b2 = false;
              b3 = !b3 ;
              b4 = false;
            });
          },
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 5.0),
        child: CategoryButton(
          bgColour: b4? kSelected: Colors.white,
          iconBgColour: Colors.green,
          icon: Icons.celebration,
          iconColour: Colors.white,
          text: 'Advanced',
          onTap: (){
            setState(() {
              b1 = false;
              b2 = false;
              b3 = false;
              b4 = !b4 ;
            });
          },
        ),
      ),
    ];

    return widget.isListView ? SizedBox(
      width: double.infinity,
      height: 55.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: cats.length,
          itemBuilder: (context, index){
            return cats[index];
          }),
    )
        :Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:  [
            CategoryButton(
              bgColour: b1? kSelected:Colors.white,
              iconBgColour: Colors.blue,
              icon: Icons.school_rounded,
              iconColour: Colors.white,
              text: 'All courses',
              onTap: (){
                setState(() {
                  b1 = !b1;
                  b2 = false;
                  b3 = false;
                  b4 = false;
                });
              },
            ),
            CategoryButton(
              bgColour: b2? kSelected: Colors.white,
              iconBgColour: Colors.orange,
              icon: Icons.child_care,
              iconColour: Colors.white,
              text: 'Beginner',
              onTap: (){
                setState(() {
                  b1 = false;
                  b2 = !b2 ;
                  b3 = false;
                  b4 = false;
                });
              },
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:  [
            CategoryButton(
              bgColour: b3? kSelected: Colors.white,
              iconBgColour: Colors.pinkAccent,
              icon: Icons.sports_gymnastics,
              iconColour: Colors.white,
              text: 'Intermediate',
              onTap: (){
                setState(() {
                  b1 = false;
                  b2 = false;
                  b3 = !b3 ;
                  b4 = false;
                });
              },
            ),
            CategoryButton(
              bgColour: b4? kSelected: Colors.white,
              iconBgColour: Colors.green,
              icon: Icons.celebration,
              iconColour: Colors.white,
              text: 'Advanced',
              onTap: (){
                setState(() {
                  b1 = false;
                  b2 = false;
                  b3 = false;
                  b4 = !b4 ;
                });
              },
            ),
          ],
        )
      ],
    );
  }
}


