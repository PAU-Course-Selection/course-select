import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:course_select/controllers/course_controller.dart';
import 'package:course_select/controllers/user_controller.dart';
import 'package:course_select/routes/routes.dart';
import 'package:course_select/shared_widgets/category_button.dart';
import 'package:course_select/shared_widgets/constants.dart';
import 'package:course_select/shared_widgets/course_card.dart';
import 'package:course_select/utils/firebase_data_management.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'auth.dart';

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

  final TextEditingController _controllerSearch = TextEditingController();



  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _title() {
    return const Text('Home');
  }

  String _userName() {
    for(var student in userController.usersList){
      if (student.email == user?.email){
         return student.displayName?? '';
      }
    }
    return '';
  }

  Widget _date() {
    for(var student in userController.usersList){
      if (student.email == user?.email){
        DateTime date = student.dateCreated.toDate();
        return Text(date.toString());
      }
    }
    return const Text('');
  }

  Widget _signOutButton() {
    return ElevatedButton(
      onPressed: () => {
        signOut(),
        Get.offAndToNamed(PageRoutes.loginRegister)},
      child: const Text('Sign Out'),
    );
  }

  Future getModels(){
    db.getUsers(userController);
    return db.getCourses(courseController);
  }

  @override
  void initState() {
    super.initState();
    getModels();
  }

  int _currentIndex = 0;
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }



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
            icon: const Icon(Icons.star_border),
            title: const Text('My courses'),
            activeColor: kPrimaryColour,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.notification_add),
            title: const Text(
              'Inbox',
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
      body: FutureBuilder(
        future: getModels(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          double screenWidth = MediaQuery.of(context).size.width;
          /// The snapshot data type have to be same of the result of your web service method
          if (snapshot.connectionState == ConnectionState.done) {
            /// When the result of the future call respond and has data show that data
            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(25),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 100.h,
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:  [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:  [
                                const Text('Hello,', style: TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Roboto'),),
                                Text(_userName(), style: kHeadlineMedium.copyWith(fontSize: 30)),
                              ],
                            ),
                        GestureDetector(
                          onTap: () => Get.toNamed(PageRoutes.userProfile),
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: SizedBox(
                                child: ClipOval(
                                  child: Image.asset("assets/images/avatar.jpg",
                                  ),
                                )
                            )
                          ),
                        )],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: const [
                              BoxShadow(
                                  color: Color.fromRGBO(143, 148, 251, .2),
                                  blurRadius: 10.0,
                                  offset: Offset(0, 5)
                              ),
                              BoxShadow(
                                  color: Color.fromRGBO(143, 148, 251, .1),
                                  blurRadius: 10.0,
                                  offset: Offset(0, 5)
                              )
                            ]
                        ),
                        padding: EdgeInsets.all(15),
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text('Search', style: TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Roboto')),
                            Icon(Icons.search, color: Color(0xff0DAB76),)
                          ],
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.only(top: 30, bottom: 20),
                        child: Text('Courses', style: kHeadlineMedium,),
                      ),

                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: const [
                              CategoryButton(bgColour: Colors.white, iconBgColour: Colors.blue, icon: Icons.school_rounded, iconColour: Colors.white, text: 'All courses',),
                              CategoryButton(bgColour: Color(0xffF2F3D9), iconBgColour: Colors.orange, icon: Icons.child_care, iconColour: Colors.white, text: 'Beginner',),
                            ],
                          ),
                          SizedBox(height: 15,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: const [
                              CategoryButton(bgColour: Colors.white, iconBgColour: Colors.pinkAccent, icon: Icons.sports_gymnastics, iconColour: Colors.white, text: 'Intermediate',),
                              CategoryButton(bgColour: Colors.white, iconBgColour: Colors.green, icon: Icons.celebration, iconColour: Colors.white, text: 'Advanced',),
                            ],
                          )
                        ],
                      ),

                      const SizedBox(height: 20,),

                      SizedBox(
                        height: 300,
                        width: double.infinity,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                            itemCount: 3,
                            itemBuilder: (context, index) {
                              return Card(
                                child: CourseCard(courseTitle: courseController.courseList[index].courseName, courseImage: 'assets/images/course_image.png',),
                              );
                            }),
                      ),],
                  ),
                ),
              ),
            );
          }else if(snapshot.hasError) {
            return const Center(child: Text('Oops...something happened',style: TextStyle(color: Colors.black),),);
          }
          /// While there is no data or error show some shimmer
          return const Center(child: Text('No data'));
        }),
    );
  }
}