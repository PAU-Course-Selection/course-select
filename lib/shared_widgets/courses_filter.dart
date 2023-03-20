import 'package:course_select/screens/search_sheet.dart';
import 'package:course_select/shared_widgets/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../controllers/home_page_notifier.dart';
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
  bool isAllSelected = false;
  bool isOngoingSelected = false;
  bool isCompletedSelected = false;

   Future _showSearchSheet(filter){
    return showCupertinoModalBottomSheet(
      expand: true,
      duration: const Duration(milliseconds: 100),
      topRadius: const Radius.circular(20) ,
      barrierColor: Colors.black54,
      elevation: 8,
      context: context,
      builder: (context) => SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Material(child: SearchSheet(filter: filter))),
    );
  }

  @override
  Widget build(BuildContext context) {
    HomePageNotifier homePageNotifier = Provider.of<HomePageNotifier>(context, listen: false);
    List<Widget> cats = [
      Padding(
        padding: const EdgeInsets.only(right: 5.0),
        child: CategoryButton(
          bgColour: b1? kSelected:Colors.white,
          iconBgColour: kPrimaryColour,
          icon: Icons.library_books,
          iconColour: Colors.white,
          text: 'All courses',
          onTap: (){
            setState(() {
              b1 = !b1;
              b2 = false;
              b3 = false;
              b4 = false;
              isAllSelected = true;
              homePageNotifier.tabIndex = 0;
            });
          },
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 5.0),
        child: CategoryButton(
          bgColour: b2? kSelected: Colors.white,
          iconBgColour: Colors.blueGrey,
          icon: Icons.class_rounded,
          iconColour: Colors.white,
          text: 'Ongoing',
          onTap: (){
            setState(() {
              b1 = false;
              b2 = !b2 ;
              b3 = false;
              b4 = false;
              isOngoingSelected = true;
              homePageNotifier.tabIndex = 1;
            });


          },
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 5.0),
        child: CategoryButton(
          bgColour: b3? kSelected: Colors.white,
          iconBgColour: Colors.blueAccent,
          icon: Icons.check_circle_rounded,
          iconColour: Colors.white,
          text: 'Completed',
          onTap: (){
            setState(() {
              b1 = false;
              b2 = false;
              b3 = !b3 ;
              b4 = false;
              isCompletedSelected = true;
              homePageNotifier.tabIndex = 2;
            });
          },
        ),
      ),
    ];

    return widget.isListView ? SizedBox(
      width: double.infinity,
      height: 58.h,
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
                _showSearchSheet('all').whenComplete(() {
                  setState(() {
                    b1 = false;
                  });
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
                _showSearchSheet('beginner').whenComplete(() {
                  setState(() {
                    b2 = false;
                  });

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
                _showSearchSheet('intermediate').whenComplete(() {
                  setState(() {
                    b3 = false;
                  });

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
                _showSearchSheet('advanced').whenComplete(() {
                  setState(() {
                    b4 = false;
                  });

                });
              },
            ),
          ],
        )
      ],
    );
  }
}


