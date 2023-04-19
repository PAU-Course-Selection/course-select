import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:course_select/screens/home_page.dart';
import 'package:course_select/screens/saved_courses_page.dart';
import 'package:course_select/screens/timetable_page.dart';
import 'package:course_select/constants/constants.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:get/get.dart';
import 'my_courses_page.dart';

/// The [AppMainNav] class controls the navigation of the app around the bottom navigation bar
class AppMainNav extends StatefulWidget {
  const AppMainNav({Key? key}) : super(key: key);

  @override
  State<AppMainNav> createState() => _AppMainNavState();
}

class _AppMainNavState extends State<AppMainNav> {
  int _currentIndex = 0;

  ///List of Nav Screens
  late final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    const MyCourses(),
    const SavedCourses(),
    const Timetable(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        showElevation: true,
        itemCornerRadius: 24,
        curve: Curves.easeIn,
        onItemSelected: (index) => setState(() => _currentIndex = index),
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            icon: const Icon(Icons.library_books_outlined),
            title: Text('home'.tr),
            activeColor: kPrimaryColour,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: const ImageIcon(AssetImage('assets/icons/book.png')),
            title: Text('course'.tr),
            activeColor: kPrimaryColour,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.bookmarks_outlined),
            title: Text(
              'saved'.tr,
            ),
            activeColor: kPrimaryColour,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.calendar_month),
            title: Text('timetable'.tr),
            activeColor: kPrimaryColour,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_currentIndex),
    );
  }
}

/// The [RaisedContainer] class defines custom styling for the filter box.
class RaisedContainer extends StatelessWidget {
  final Widget child;
  final double width;
  final Color bgColour;
  const RaisedContainer({
    Key? key, required this.child, required this.width, required this.bgColour,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: bgColour,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
                color: Color.fromRGBO(143, 148, 251, .2),
                blurRadius: 10.0,
                offset: Offset(0, 5)),
            BoxShadow(
                color: Color.fromRGBO(143, 148, 251, .1),
                blurRadius: 10.0,
                offset: Offset(0, 5))
          ]),
      padding: const EdgeInsets.all(15),
      width: width,
      child: child
    );
  }
}