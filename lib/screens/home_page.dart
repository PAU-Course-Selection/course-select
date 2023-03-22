import 'package:cached_network_image/cached_network_image.dart';
import 'package:course_select/controllers/home_page_notifier.dart';
import 'package:course_select/controllers/user_notifier.dart';
import 'package:course_select/screens/search_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import '../constants/constants.dart';
import '../controllers/course_notifier.dart';
import '../routes/routes.dart';
import '../shared_widgets/active_course_tile.dart';
import '../shared_widgets/category_title.dart';
import '../shared_widgets/course_card.dart';
import '../shared_widgets/courses_filter.dart';
import '../shared_widgets/filter_button.dart';
import '../utils/firebase_data_management.dart';
import 'app_main_navigation.dart';
import 'my_courses_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final ValueNotifier<double> valueNotifier;
  late final CourseNotifier courseNotifier;
  late final UserNotifier userNotifier;
  late Future futureData;

  final DatabaseManager _db = DatabaseManager();

  @override
  void initState() {
    courseNotifier = Provider.of<CourseNotifier>(context, listen: false);
    userNotifier = Provider.of<UserNotifier>(context, listen: false);
    futureData = getModels();

    valueNotifier = ValueNotifier(0.0);
    _db.getUsers(userNotifier);
    super.initState();
  }


  Future getModels() async{
    await _db.getUsers(userNotifier);
    userNotifier.updateUserName();
    userNotifier.updateAvatar();
    return _db.getCourses(courseNotifier);
  }

  @override
  Widget build(BuildContext context) {
    //final Size _size = MediaQuery.of(context).size;
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
                                        const Text(
                                          'Hello,',
                                          style: TextStyle(
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
                                        builder: (context) => const Material(child: SearchSheet(filter: 'all',)),
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
                             CategoryTitle(text: 'Currently Active', onPressed: (){
                               homePageNotifier.isOngoingSelected = true;
                               homePageNotifier.tabIndex = 1;
                               Navigator.pushNamed(context, PageRoutes.courses);
                            },),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 25.0),
                              child: ActiveCourseTile(valueNotifier: valueNotifier, courseImage: 'assets/images/html.jpg', courseName: 'Symmetry Theory', remainingLessons: 10,),
                            ),
                             CategoryTitle(text: 'Top Picks', onPressed: (){
                               homePageNotifier.isAllSelected = true;
                               homePageNotifier.tabIndex = 0;
                               Navigator.pushNamed(context, PageRoutes.courses);
                            },), //Courses Title
                            Padding(
                              padding: const EdgeInsets.only(left: 25.0),
                              child: SizedBox(
                                height: 280,
                                width: double.infinity,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: courseNotifier.courseList.length,
                                    itemBuilder: (context, index) {
                                      var courseName = courseNotifier
                                          .courseList[index].courseName;
                                      return GestureDetector(
                                        onTap: (){
                                        courseNotifier.currentCourse = courseNotifier.courseList[index];
                                          Navigator.pushNamed(context, PageRoutes.courseInfo);
                                        },
                                        child: CourseCard(
                                          courseTitle: courseName.length > 30? courseName.substring(0,30) +'...': courseName,
                                          courseImage: courseNotifier.courseList[index].media[1],
                                          subjectArea: courseNotifier.courseList[index].subjectArea, hoursPerWeek: courseNotifier.courseList[index].duration,
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
              return const Center(
                child: Text(
                  'Oops...something happened',
                  style: TextStyle(color: Colors.black),
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
            return const Center(child: Text('No data'));
          }),
    );
  }

}


