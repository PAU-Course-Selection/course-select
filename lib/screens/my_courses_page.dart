import 'package:course_select/controllers/home_page_notifier.dart';
import 'package:course_select/shared_widgets/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../controllers/course_notifier.dart';
import '../controllers/user_notifier.dart';
import '../models/course_data_model.dart';
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
  late final UserNotifier userNotifier;
  late Future futureData;

  // static List<Course> courses = [
  //   Course(
  //       'Computer Science',
  //       'Beginner',
  //       'CS101',
  //       'Introduction to Computer Science',
  //       3,
  //       16,
  //       ['None'],
  //       false,
  //       'assets/images/html.jpg', []),
  //   Course('Business', 'Intermediate', 'BUS504', 'Marketing Management', 4, 12,
  //       ['BUS501'], false, 'assets/images/html.jpg',[]),
  //   Course('Mathematics', 'Master', 'MATH201', 'Calculus I', 4, 16, ['MATH101'],
  //       false, 'assets/images/html.jpg',[]),
  //   Course('History', 'Beginner', 'HIST101', 'Introduction to World History', 3,
  //       12, ['None'], false, 'assets/images/html.jpg',[]),
  //   Course('Chemistry', 'Master', 'CHEM601', 'Advanced Organic Chemistry', 5,
  //       16, ['CHEM501'], false, 'assets/images/html.jpg',[])
  // ];

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
    userNotifier = Provider.of<UserNotifier>(context, listen: false);
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
                                  return Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 10.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color:
                                            kLightBackground.withOpacity(0.2),
                                      ),
                                      child: Stack(
                                        children: [
                                          Container(
                                              padding: const EdgeInsets.all(15),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              height: 100,
                                              width: 100,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                        displayList[index]
                                                            .media[1]),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              )),
                                          Positioned(
                                            left: 80.w,
                                            child: Container(
                                              padding: const EdgeInsets.all(15),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    displayList[index]
                                                                .courseName
                                                                .length >
                                                            20
                                                        ? displayList[index]
                                                                .courseName
                                                                .substring(
                                                                    0, 20) +
                                                            '...'
                                                        : displayList[index]
                                                            .courseName,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    displayList[index]
                                                        .subjectArea,
                                                    style: const TextStyle(
                                                        fontSize: 16),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5.0),
                                                    child: Text(
                                                      '${displayList[index].duration} weeks',
                                                      style: const TextStyle(
                                                          color: Colors.grey),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                              right: 10,
                                              child: GestureDetector(
                                                onTap: () {
                                                  HapticFeedback.heavyImpact();
                                                  setState(() {
                                                    displayList[index].isSaved =
                                                        !displayList[index]
                                                            .isSaved;
                                                  });
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(15),
                                                  child: displayList[index]
                                                          .isSaved
                                                      ? Animate(
                                                          child: Icon(
                                                              Icons
                                                                  .bookmark_added,
                                                              color:
                                                                  kPrimaryColour),
                                                        )
                                                          .animate()
                                                          .shake(
                                                              hz: 1,
                                                              curve: Curves
                                                                  .easeInOutCubic,
                                                              duration: 500.ms)
                                                          .shimmer(
                                                              delay: 10.ms,
                                                              duration: 1000.ms)
                                                          .scaleXY(
                                                              end: 1.2,
                                                              duration: 100.ms)
                                                          .then(delay: 1.ms)
                                                          .scaleXY(
                                                              end: 1 / 1.2,
                                                              curve: Curves
                                                                  .bounceInOut)
                                                      : Icon(
                                                          Icons
                                                              .bookmark_border_rounded,
                                                          color: Colors.orange
                                                              .withOpacity(0.5),
                                                        ),
                                                ),
                                              )),
                                          Positioned(
                                            right: 0,
                                            bottom: 0,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: kPrimaryColour
                                                      .withOpacity(0.2),
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  10))),
                                              height: 30,
                                              width: 100.w,
                                              child: Center(
                                                  child: Text(displayList[index]
                                                      .level)),
                                            ),
                                          )
                                        ],
                                      ),
                                      width: double.infinity,
                                    ),
                                  );
                                })),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
