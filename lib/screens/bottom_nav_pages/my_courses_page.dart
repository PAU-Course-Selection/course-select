import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_select/controllers/home_page_notifier.dart';
import 'package:course_select/shared_widgets/filtering/courses_filter.dart';
import 'package:course_select/auth/auth.dart';
import 'package:course_select/shared_widgets/list_items/ongoing_course_tile.dart';
import 'package:course_select/shared_widgets/list_items/completed_course_tile.dart';
import 'package:course_select/shared_widgets/list_items/enrolled_course_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../constants/constants.dart';
import '../../controllers/course_notifier.dart';
import '../../controllers/user_notifier.dart';
import '../../models/course_data_model.dart';
import '../../models/saved_course_data_model.dart';
import '../../routes/routes.dart';
import '../../shared_widgets/list_items/mini_course_card.dart';
import '../../firestore/firebase_data_management.dart';

class MyCourses extends StatefulWidget {
  const MyCourses({Key? key}) : super(key: key);

  @override
  State<MyCourses> createState() => _MyCoursesState();
}

class _MyCoursesState extends State<MyCourses>
    with SingleTickerProviderStateMixin {
  DatabaseManager db = DatabaseManager();
  late final CourseNotifier courseNotifier;
  late final SavedCoursesNotifier savedCoursesNotifier;
  final User? user = Auth().currentUser;
  late ValueNotifier<double> _valueNotifier;
  late int tabIndex;

  // Get the current user's ID
  final userId = Auth().currentUser!.uid;
  late String id;

  // Get a reference to the user's document in the "users" collection
  late final DocumentReference<Map<String, dynamic>> userRef;

  late final UserNotifier userNotifier;
  late Future futureData;
  late final AnimationController _animationController;

  late List<Course> displayList;
  late List<Course> displayOngoingList;
  late List<Course> displayCompletedList;
  late List<Course> savedList;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this);
    courseNotifier = Provider.of<CourseNotifier>(context, listen: false);
    savedCoursesNotifier =
        Provider.of<SavedCoursesNotifier>(context, listen: false);
    userRef = FirebaseFirestore.instance.collection('Users').doc(userId);
    userNotifier = Provider.of<UserNotifier>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      savedList = userNotifier.filterCoursesByIds(courseNotifier.courseList);
    });

    futureData = getModels();

    displayList = List.from(courseNotifier.courseList);
    displayOngoingList = List.from(displayList.where((element) =>
        userNotifier.userCourseIds.contains(element.courseId)));
    displayCompletedList = List.from(displayList.where((element) =>
        userNotifier.completedCourseIds.contains(element.courseId)));
    // for (var compCourse in displayCompletedList) {
    //  // print('COMPCOMPCOMPCOURSEINLIST ${compCourse.courseName}');
    // }
    super.initState();
  }

  void updateList(String value) {
    /// filter courses list
    setState(() {
      displayList = courseNotifier.courseList
          .where((element) =>
              element.courseName.toLowerCase().contains(value.toLowerCase()) ||
              element.subjectArea.toLowerCase()
                  .contains(value.toLowerCase()) ||
              element.level.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  void updateOngoingList(String value) {
    /// filter courses list
    setState(() {
      displayOngoingList = courseNotifier.courseList
          .where((element) =>
              userNotifier.userCourseIds.contains(element.courseId) &&
                  element.courseName.toLowerCase()
                      .contains(value.toLowerCase()) ||
              element.subjectArea.toLowerCase()
                  .contains(value.toLowerCase()) ||
              element.level.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  void updateEnrolledList() {
    setState(() {
      savedList = userNotifier.filterCoursesByIds(displayList);
    });
  }

  void updateCompletedList(String value) {
    setState(() {
      displayCompletedList = courseNotifier.courseList
          .where((element) =>
              userNotifier.completedCourseIds.contains(element.courseId) &&
                  element.courseName.toLowerCase()
                      .contains(value.toLowerCase()) ||
              element.subjectArea.toLowerCase()
                  .contains(value.toLowerCase()) ||
              element.level.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  Future getModels() {
    db.getUsersFromDb(userNotifier);
    return db.getCoursesFromDb(courseNotifier);
  }

  int duplicateCount = 0;

  Widget _showList(int index) {
    HomePageNotifier homePageNotifier =
        Provider.of<HomePageNotifier>(context, listen: true);
    switch (index) {
      case 0:
        return Expanded(
            child: displayList.isEmpty
                ? const Center(
                    child: Text('No results found...'),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: displayList.length,
                        itemBuilder: (context, index) {
                          return MiniCourseCard(
                            displayList: displayList,
                            index: index,
                            onBookmarkTapped: () {
                              setState(() {
                                HapticFeedback.heavyImpact();
                                displayList[index].isSaved =
                                    !displayList[index].isSaved;
                                courseNotifier.currentCourse =
                                    courseNotifier.courseList[index];
                                // Add the course as a favorite
                                db.addSavedCourseSubCollection(
                                    index: index,
                                    displayList: displayList,
                                    duplicateCount: duplicateCount,
                                    savedCourses: savedCoursesNotifier,
                                    courseNotifier: courseNotifier);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    elevation: 1,
                                    behavior: SnackBarBehavior.fixed,
                                    backgroundColor: kKindaGreen,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    content: Center(
                                        child: Text(
                                      displayList[index].isSaved
                                          ? 'Added to saved courses'
                                          : 'Removed from saved courses',
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    )),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              });
                            },
                            onCardPressed: () {
                              courseNotifier.currentCourse = displayList[index];
                              Navigator.pushNamed(
                                  context, PageRoutes.courseInfo);
                            },
                          );
                        }),
                  ));
      case 1:
        return Expanded(
            child: savedList.isEmpty
                ? const Center(
                    child: Text('You are not enrolled on any courses...'),
                  )
                : RefreshIndicator(
                    color: kPrimaryColour,
                    onRefresh: () {
                      HapticFeedback.heavyImpact();
                      setState(() {
                        updateEnrolledList();
                        futureData = getModels();
                      });
                      return futureData;
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: savedList.length,
                          itemBuilder: (context, index) {
                            return EnrolledCourseCard(
                              displayList: savedList,
                              index: index,
                              onBookmarkTapped: () {
                                setState(() {
                                  HapticFeedback.heavyImpact();
                                  savedList[index].isSaved =
                                      !savedList[index].isSaved;
                                  courseNotifier.currentCourse = savedList[index];
                                  // Add the course as a favorite
                                  db.addSavedCourseSubCollection(
                                      index: index,
                                      displayList: savedList,
                                      duplicateCount: duplicateCount,
                                      savedCourses: savedCoursesNotifier,
                                      courseNotifier: courseNotifier);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      elevation: 1,
                                      behavior: SnackBarBehavior.fixed,
                                      backgroundColor: kKindaGreen,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      content: Center(
                                          child: Text(
                                        displayList[index].isSaved
                                            ? 'Added to saved courses'
                                            : 'Removed from saved courses',
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      )),
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                                });
                              },
                              onCardPressed: () => {
                                /// set current course to click card of user's courses
                                courseNotifier.currentCourse = savedList[index],
                                Navigator.pushNamed(
                                    context, PageRoutes.courseInfo),
                              },
                            );
                          }),
                    ),
                  ));
      case 2:
        return Expanded(
            child: displayOngoingList.isEmpty
                ? const Center(
                    child: Text('No ongoing courses found...'),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: displayOngoingList.length,
                        itemBuilder: (context, index) {
                          return OngoingCourseTile(
                            valueNotifier:
                                _setValueNotifier(displayOngoingList[index]),
                            courseName: displayOngoingList[index].courseName,
                            courseImage: displayOngoingList[index].media[1],
                            remainingLessons:
                                displayOngoingList[index].totalLessons,
                          );
                        }),
                  ));
        break;
      case 3:
        return Expanded(
            child: displayCompletedList.isEmpty
                ? const Center(
                    child: Text('No completed courses found...'),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: displayCompletedList.length,
                        itemBuilder: (context, index) {
                          return CompletedCourseTile(
                            index: index,
                            displayList: displayCompletedList,
                          );
                        }),
                  ));
      default:
        return Expanded(
            child: displayList.isEmpty
                ? const Center(
                    child: Text('No results found...'),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: displayList.length,
                        itemBuilder: (context, index) {
                          return MiniCourseCard(
                            displayList: displayList,
                            index: index,
                            onBookmarkTapped: () {
                              setState(() {
                                HapticFeedback.heavyImpact();
                                displayList[index].isSaved =
                                    !displayList[index].isSaved;

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    elevation: 1,
                                    behavior: SnackBarBehavior.fixed,
                                    backgroundColor: kKindaGreen,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    content: Center(
                                        child: Text(
                                      displayList[index].isSaved
                                          ? 'Added to saved courses'
                                          : 'Removed from saved courses',
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    )),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              });
                            },
                            onCardPressed: () {
                              courseNotifier.currentCourse = displayList[index];
                              Navigator.pushNamed(
                                  context, PageRoutes.courseInfo);
                            },
                          );
                        }),
                  ));
    }
  }

  getMyCourses() async {
    await db.getCoursesFromDb(courseNotifier).then((value) {
      setState(() {
        savedList = userNotifier.filterCoursesByIds(value);
      });
    });
    return savedList;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  ValueNotifier<double> _setValueNotifier(Course course) {
    return _valueNotifier =
        ValueNotifier(calculateCompletionPercentage(course));
  }

  @override
  Widget build(BuildContext context) {
    HomePageNotifier homePageNotifier =
        Provider.of<HomePageNotifier>(context, listen: true);

    tabIndex = homePageNotifier.tabIndex;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Courses',
          style: kHeadlineMedium,
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: FutureBuilder(
          future: futureData,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            return Padding(
              padding: const EdgeInsets.all(0),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20.0,
                    ),
                    SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 20),
                        child: TextField(
                          onChanged: (value) {
                            updateList(value);
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              hintText: 'eg. Introduction to HTML',
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8.0)),
                                  borderSide: BorderSide(
                                      width: 1, color: kPrimaryColour)),
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Colors.grey,
                              ),
                              focusColor: kPrimaryColour),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 25.0),
                      child: CoursesFilter(isListView: true),
                    ),
                    const SizedBox(
                      height: 25.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0, bottom: 10),
                      child: Text(
                        tabIndex == 0
                            ? 'All courses'
                            : tabIndex == 1
                                ? 'Enrolled'
                                : tabIndex == 2
                                    ? 'Ongoing'
                                    : 'Completed',
                        style: const TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto'),
                      ),
                    ),
                    _showList(tabIndex)
                  ],
                ),
              ),
            );
          }),
    );
  }

  // static final List<MyCourse> _myCourses = [
  //   MyCourse("Introduction to Programming", "assets/images/c2.jpg", 20, 15),
  //   MyCourse("Web Development with HTML/CSS", "assets/images/c2.jpg", 30, 20),
  //   MyCourse("Data Science Fundamentals", "assets/images/c2.jpg", 25, 5),
  //   MyCourse("Mobile App Development", "assets/images/c2.jpg", 40, 10),
  // ];

  double calculateCompletionPercentage(Course course) {
    double completionPercentage =
        (course.totalLessons - course.totalLessons) / course.totalLessons * 100;
    return completionPercentage;
  }
}

class MyCourse {
  String courseName;
  String courseImage;
  int remainingLessons;
  int numLessons;

  MyCourse(this.courseName, this.courseImage, this.numLessons,
      this.remainingLessons);
}