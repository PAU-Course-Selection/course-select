import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:course_select/controllers/course_controller.dart';
import 'package:course_select/controllers/user_controller.dart';
import 'package:course_select/routes/routes.dart';
import 'package:course_select/screens/notifications_page.dart';
import 'package:course_select/screens/timetable_page.dart';
import 'package:course_select/shared_widgets/courses_filter.dart';
import 'package:course_select/shared_widgets/constants.dart';
import 'package:course_select/shared_widgets/course_card.dart';
import 'package:course_select/utils/firebase_data_management.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';

import 'auth.dart';
import 'my_courses_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ///Instantiates
  final User? user = Auth().currentUser;
  DatabaseManager db = DatabaseManager();
  final userController = Get.put(UserController());
  final courseController = Get.put(CourseController());

  Future<void> signOut() async {
    await Auth().signOut();
  }

  String _userName() {
    for(var student in userController.usersList){
      if (student.email == user?.email){
         return student.displayName?? '';
      }
    }
    return '';
  }
  String _avatar(){
    try {
      for (var student in userController.usersList) {
        if (student.email == user?.email) {
          return student.avatar ?? '';
        }
      }
    }on ArgumentError catch(e) {
      print(e);
    }
    return '';
  }

  Future getModels(){
    db.getUsers(userController);
    return db.getCourses(courseController);
  }

  @override
  void initState() {
    super.initState();
    valueNotifier = ValueNotifier(0.0);
    getModels();
  }

  int _currentIndex = 0;
  bool _isFilterVisible = true;
  late ValueNotifier<double> valueNotifier;
  SolidController _controller = SolidController();

  ///List of Nav Screens
  late final List<Widget> _widgetOptions = <Widget>[
    FutureBuilder(
        future: getModels(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          double screenWidth = MediaQuery.of(context).size.width;
          /// The snapshot data type have to be same of the result of your web service method
          if (snapshot.connectionState == ConnectionState.done) {
            /// When the result of the future call respond and has data show that data
            return Column(
              children: [
                SafeArea(
                    child: Container(
                      padding: EdgeInsets.only(bottom: 25),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 100.h,
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 25),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Hello,',
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                            fontFamily: 'Roboto'),
                                      ),
                                      Text(_userName(),
                                          style:
                                          kHeadlineMedium.copyWith(fontSize: 30)),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () => Get.toNamed(PageRoutes.userProfile),
                                    child:  CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Colors.white,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(45),
                                          child: CachedNetworkImage(
                                            fit: BoxFit.fill,
                                            imageUrl: _avatar(),
                                            placeholder: (context, url){
                                              return  CircularProgressIndicator(strokeWidth: 2, color: kPrimaryColour,);
                                            },
                                            errorWidget: (context, url, error) => const Icon(Icons.person, color: Colors.grey,),
                                          ),
                                        )),
                                  )
                                ],
                              ),
                            ),//Name and Avatar
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap:(){
                                    showCupertinoModalBottomSheet(
                                      duration: const Duration(milliseconds: 100),
                                      topRadius: const Radius.circular(20) ,
                                      barrierColor: Colors.black54,
                                      elevation: 8,
                                      context: context,
                                      builder: (context) => const Material(child: MyCourses()),
                                    );
                                  },
                                  child: RaisedContainer(child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Search',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 16,
                                              fontFamily: 'Roboto')),
                                      Icon(
                                        Icons.search,
                                        color: const Color(0xff0DAB76).withOpacity(0.7),
                                      )
                                    ],
                                  ), width: screenWidth * 0.73, bgColour: Colors.white,),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isFilterVisible = !_isFilterVisible;
                                        _refreshKey = UniqueKey();
                                      });
                                    },
                                    child: RaisedContainer(width: 50, bgColour: _isFilterVisible?kPrimaryColour:Colors.white,
                                      child: ImageIcon(const AssetImage('assets/icons/setting.png'), color: _isFilterVisible? Colors.white: kPrimaryColour),

                                    ),
                                  ),
                                )],
                            ),
                          ),
                        ],
                      ),
                    )
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                            visible: _isFilterVisible,
                            child: CoursesFilter()), //Course Filters
                        const CategoryTitle(text: 'Currently Active'),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              color:  kLightBackground.withOpacity(0.2),
                            ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.red,
                                        image: const DecorationImage(image: AssetImage('assets/images/html.jpg'))),
                                    height: 70,
                                    width: 70,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const [
                                      Text('Symmetry Theory', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text('2 lessons left', style: TextStyle(color: Colors.grey),)
                                    ],
                                  ),
                                  SimpleCircularProgressBar(
                                    animationDuration: 1,
                                    backColor: const Color(0xffD9D9D9),
                                    progressColors: [kSelected,kPrimaryColour],
                                    progressStrokeWidth: 8,
                                    backStrokeWidth: 8,
                                    size: 50,
                                    valueNotifier: valueNotifier,
                                    mergeMode: true,
                                    onGetText: (double value) {
                                      return Text('${value.toInt()}%');
                                    },
                                  ),


                                ],
                              ),
                              width: double.infinity,),
                        ),//Courses Title
                        const CategoryTitle(text: 'Top Picks'), //Courses Title
                        Padding(
                          padding: const EdgeInsets.only(left: 25.0),
                          child: SizedBox(
                            height: 300,
                            width: double.infinity,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 3,
                                itemBuilder: (context, index) {
                                  return Card(
                                    child: CourseCard(
                                      courseTitle: courseController
                                          .courseList[index].courseName,
                                      courseImage: 'assets/images/course_image.png',
                                    ),
                                  );
                                }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Oops...something happened',
                style: TextStyle(color: Colors.black),
              ),
            );
          }

          /// While there is no data or error show some shimmer
          return const Center(child: Text('No data'));
        }),
    const MyCourses(),
    const Notifications(),
    const Timetable(),
  ];

  Key _refreshKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    valueNotifier.value = 80.0;
    return Scaffold(
      key: _refreshKey,
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