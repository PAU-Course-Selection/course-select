import 'package:cached_network_image/cached_network_image.dart';
import 'package:course_select/controllers/home_page_notifier.dart';
import 'package:course_select/shared_widgets/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../controllers/course_notifier.dart';
import '../controllers/user_notifier.dart';
import '../models/course_data_model.dart';
import '../shared_widgets/mini_course_card.dart';
import '../utils/firebase_data_management.dart';

class MyCourses extends StatefulWidget {
  const MyCourses({Key? key}) : super(key: key);

  @override
  State<MyCourses> createState() => _MyCoursesState();
}

class _MyCoursesState extends State<MyCourses>
    with SingleTickerProviderStateMixin {
  DatabaseManager db = DatabaseManager();
  HomePageNotifier homePageNotifier = HomePageNotifier();
  late final CourseNotifier courseNotifier;
  //late final UserNotifier userNotifier;
  late Future futureData;

  late List<Course> displayList;

  void updateList(String value) {
    /// filter courses list
    setState(() {
      displayList = courseNotifier.courseList
          .where((element) =>
              element.courseName!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  Future getModels() {
    //db.getUsers(userNotifier);
    return db.getCourses(courseNotifier);
  }

  late final AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this);
    courseNotifier = Provider.of<CourseNotifier>(context, listen: false);
    //userNotifier = Provider.of<UserNotifier>(context, listen: false);
    futureData = getModels();
    displayList = List.from(courseNotifier.courseList);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: futureData,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            return Padding(
              padding: const EdgeInsets.all(25),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Search for a course',
                      style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto'),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    TextField(
                      onChanged: (value) {
                        updateList(value);
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          hintText: 'eg. Data Science',
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8.0)),
                              borderSide:
                                  BorderSide(width: 1, color: kPrimaryColour)),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          focusColor: kPrimaryColour),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Expanded(
                        child: displayList.isEmpty
                            ? const Center(
                                child: Text('No results found...'),
                              )
                            : ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: displayList.length,
                                itemBuilder: (context, index) {
                                  return MiniCourseCard(
                                    displayList: displayList,
                                    index: index,
                                    onBookmarkTapped: (){
                                      setState(() {
                                        HapticFeedback.heavyImpact();
                                        displayList[index].isSaved = !displayList[index].isSaved;
                                      });
                                    },);
                                })),
                  ],
                ),
              ),
            );
          }),
    );
  }
}


