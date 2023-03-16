import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:course_select/screens/home_page.dart';
import 'package:course_select/screens/notifications_page.dart';
import 'package:course_select/screens/timetable_page.dart';
import 'package:course_select/constants/constants.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'my_courses_page.dart';

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
    const Notifications(),
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
            title: const Text('Home'),
            activeColor: kPrimaryColour,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: const ImageIcon(AssetImage('assets/icons/courses.png')),
            title: const Text('Courses'),
            activeColor: kPrimaryColour,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.bookmarks_outlined),
            title: const Text(
              'Saved',
            ),
            activeColor: kPrimaryColour,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.calendar_month),
            title: const Text('Timetable'),
            activeColor: kPrimaryColour,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_currentIndex),
    );
  }
}

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