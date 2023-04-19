import 'package:cached_network_image/cached_network_image.dart';
import 'package:course_select/controllers/home_page_notifier.dart';
import 'package:course_select/controllers/user_notifier.dart';
import 'package:course_select/screens/search_sheet.dart';
import 'package:course_select/utils/enums.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import '../constants/constants.dart';
import '../controllers/course_notifier.dart';
import '../models/course_data_model.dart';
import '../routes/routes.dart';
import '../shared_widgets/active_course_tile.dart';
import '../shared_widgets/category_title.dart';
import '../shared_widgets/course_card.dart';
import '../shared_widgets/courses_filter.dart';
import '../shared_widgets/filter_button.dart';
import '../utils/auth.dart';
import '../utils/firebase_data_management.dart';
import 'app_main_navigation.dart';

/// [HomePage] displays the dashboard page of the app. The first page seen after logging in a selecting preferences
/// This allows users to search and filter course
/// Displays in progress courses
/// Displays recommended courses
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final ValueNotifier<double> valueNotifier;
  late final CourseNotifier _courseNotifier;
  late final UserNotifier userNotifier;
  late Future futureData;
  final User? user = Auth().currentUser;
  late List<Course> forYouList = [];

  late List userCourseIds = [];
  bool match = false;

  final DatabaseManager _db = DatabaseManager();

  /// initialises notifiers and retrieves data from the database
  @override
  void initState() {
    _courseNotifier = Provider.of<CourseNotifier>(context, listen: false);
    userNotifier = Provider.of<UserNotifier>(context, listen: false);
    _db.getTotalLessons(_courseNotifier);
    getModels();
    futureData = getModels();
    valueNotifier = ValueNotifier(0.0);
    print(user?.email);
    getForYouList();
    super.initState();
  }

  /// Gets required models for use by the screen from the database
  /// Gets users, updates user info and gets the list of courses from the database
  Future getModels() async{
    await _db.getUsers(userNotifier);
    userNotifier.updateUserDetails();
    return _db.getCourses(_courseNotifier);
  }

  /// Retrieves the list of recommmended course based on user interest selection
  /// Filters the required courses from the full list
  Future getForYouList() async{
    await _db.getUsers(userNotifier);
    await _db.getCourses(_courseNotifier);
    userNotifier.getInterests();
    setState(() {
      forYouList = filterCoursesByInterests(userNotifier.getInterests(), _courseNotifier.courseList);
    });
  }


/// Retrieves the list of courses after checking if the current user is logged in
  void getCourseIds(UserNotifier userNotifier) {
    for (int i = 0; i < userNotifier.usersList.length; i++) {
      if (userNotifier.usersList[i].email == user?.email) {
        match = true;
        print(match);
        print(userNotifier.usersList[i].email);
        userCourseIds = userNotifier.usersList[i].courses!;
      }
    }
    if(match){
      print(userCourseIds);
    } else {
      print('user not found');
    }
  }

  /// Filters courses from the full list by id, works with the search bar
  List<Course> filterCoursesByIds(List courseIds, List<Course> courses) {
    List<Course> filteredCourses = [];
    for (var course in courses) {
      //print(course.courseId);
      if (courseIds.contains(course.courseId)) {
          filteredCourses.add(course);
      }
    }
    return filteredCourses;
  }

  /// Filters courses from the full list by interest. Works with the search bar
  List<Course> filterCoursesByInterests(List interests, List<Course> courses) {
    List<Course> filteredCourses = [];
    for (var course in courses) {
      //print(course.courseId);
      if (interests.contains(course.subjectArea)) {
        filteredCourses.add(course);
      }
    }
    return filteredCourses;
  }

  /// Builds the full dashboard page UI structure
  @override
  Widget build(BuildContext context) {
    valueNotifier.value = 80.0;
    HomePageNotifier homePageNotifier = Provider.of<HomePageNotifier>(context, listen: true);

    return Scaffold(
      body: FutureBuilder(
          future: futureData,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            double screenWidth = MediaQuery.of(context).size.width;
            /// The snapshot data type have to be same of the result of your web service method
            if (snapshot.connectionState == ConnectionState.done || snapshot.connectionState == ConnectionState.waiting) {
              /// When the result of the future call respond and has data show that data
              return Column(
                children: [
                  SafeArea(
                      child: Container(
                        padding: const EdgeInsets.only(bottom: 25),
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
                                         Text(
                                          'hello,'.tr,
                                          style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 16,
                                              fontFamily: 'Roboto'),
                                        ),
                                        Text(userNotifier.userName,
                                            style:
                                            kHeadlineMedium.copyWith(fontSize: 30)),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () => Navigator.pushNamed(context, PageRoutes.userProfile),
                                      child:  CircleAvatar(
                                          radius: 20,
                                          backgroundColor: Colors.white,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(75.0),
                                            child: CachedNetworkImage(
                                              height: 100.0,
                                              width: 100.0,
                                              fit: BoxFit.cover,
                                              imageUrl: userNotifier.avatar ?? '',
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
                                        builder: (context) => const Material(child: SearchSheet(categoryFilterKeyword: CategorySearchFilter.all,)),
                                      );
                                    },
                                    child: RaisedContainer(child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                         Text(
                                            'Search'.tr,
                                            style: const TextStyle(
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
                                    child: FilterButton(
                                        isFilterVisible: homePageNotifier.isFilterVisible,
                                      onPressed: (){
                                          homePageNotifier.isFilterVisible =!homePageNotifier.isFilterVisible;
                                      },
                                    ),
                                  )],
                              ),
                            ),
                          ],
                        ),
                      )
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      color: kPrimaryColour,
                      onRefresh: () {
                        HapticFeedback.heavyImpact();
                        setState(() {
                          futureData = getModels();
                          getForYouList();
                        });
                        return futureData;
                      },
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Visibility(
                                visible: homePageNotifier.isFilterVisible,
                                child: Animate(
                                  effects: const [FadeEffect(), SlideEffect(duration: Duration(milliseconds: 50))],
                                    child:  const CoursesFilter(isListView: false))), //Course Filters
                             CategoryTitle(text: 'currently_active'.tr, onPressed: (){
                               homePageNotifier.isOngoingSelected = true;
                               homePageNotifier.tabIndex = 1;
                               Navigator.pushNamed(context, PageRoutes.courses);
                            },),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 25.0),
                              child: ActiveCourseTile(valueNotifier: valueNotifier, courseImage: 'assets/images/html.jpg', courseName: 'Symmetry Theory', remainingLessons: 10,),
                            ),
                             CategoryTitle(text: forYouList.isEmpty? 'top_picks'.tr:'for_you'.tr, onPressed: (){
                               homePageNotifier.isAllSelected = true;
                               homePageNotifier.tabIndex = 0;
                               Navigator.pushNamed(context, PageRoutes.courses);
                            },), //Courses Title
                            Padding(
                              padding: const EdgeInsets.only(left: 25.0),
                              child: SizedBox(
                                height: 250.h,
                                width: double.infinity,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: forYouList.isEmpty? _courseNotifier.courseList.length: forYouList.length,
                                    itemBuilder: (context, index) {
                                      var courseName = forYouList.isEmpty? _courseNotifier
                                          .courseList[index].courseName: forYouList[index].courseName;
                                      return GestureDetector(
                                        onTap: (){
                                        _courseNotifier.currentCourse = forYouList.isEmpty? _courseNotifier.courseList[index]: forYouList[index];
                                          Navigator.pushNamed(context, PageRoutes.courseInfo);
                                        },
                                        child: CourseCard(
                                          courseTitle: courseName.length > 30? courseName.substring(0,30) +'...': courseName,
                                          courseImage: forYouList.isEmpty? _courseNotifier.courseList[index].media[1]: forYouList[index].media[1],
                                          subjectArea: forYouList.isEmpty? _courseNotifier.courseList[index].subjectArea: forYouList[index].subjectArea,
                                          hoursPerWeek:forYouList.isEmpty?_courseNotifier.courseList[index].duration: forYouList[index].duration,
                                          numLessons: forYouList.isEmpty? _courseNotifier.courseList[index].totalLessons: forYouList[index].totalLessons
                                        ),
                                      );
                                    }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return  Center(
                child: Text(
                  'oops'.tr,
                  style: const TextStyle(color: Colors.black),
                ),
              );
            }
            // else if(snapshot.connectionState == ConnectionState.waiting){
            //   ///should be shimmer instead
            //   return const Center(child: Text('Shimmer for show'),);
            // }else{
            //   const Center(child: Text('waiting...'));
            // }

            /// While there is no data or error show some shimmer
            return Center(child: Text('No_data'.tr));
          }),
    );
  }

}


