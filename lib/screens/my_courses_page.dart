import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_select/controllers/home_page_notifier.dart';
import 'package:course_select/shared_widgets/courses_filter.dart';
import 'package:course_select/utils/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../constants/constants.dart';
import '../controllers/course_notifier.dart';
import '../controllers/user_notifier.dart';
import '../models/course_data_model.dart';
import '../models/saved_course_data_model.dart';
import '../routes/routes.dart';
import '../shared_widgets/active_course_tile.dart';
import '../shared_widgets/completed_course_tile.dart';
import '../shared_widgets/enrolled_course_card.dart';
import '../shared_widgets/mini_course_card.dart';
import '../utils/firebase_data_management.dart';

/// [MyCourses] allows a user to view all courses, as well as enrolled, ongoing and completed courses.
/// A user can also filter each of these categories using the search bar
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
  late List<MyCourse> displayOngoingList;
  late List<Course> myList;

  /// filter courses list based on search bar input
  void updateList(String value) {
    setState(() {
      displayList = courseNotifier.courseList
          .where((element) =>
              element.courseName!.toLowerCase().contains(value.toLowerCase()) ||
              element.subjectArea!
                  .toLowerCase()
                  .contains(value.toLowerCase()) ||
              element.level!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  /// Filters ongoing course list based on course name from search bar input
  void updateOngoingList(String value) {
    /// filter courses list
    setState(() {
      displayOngoingList = _myCourses
          .where((element) =>
              element.courseName!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  /// Filters enrolled course list based on search input from search bar
  void updateEnrolledList(){
    setState(() {
      myList = userNotifier.filterCoursesByIds(displayList);
    });
  }

  /// Get users and courses from the database
  Future getModels() {
    db.getUsers(userNotifier);
    return db.getCourses(courseNotifier);
  }

  /// counts the number of duplicates in the saved courses list
  /// Ensure duplicate entries can't be created
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
            child: myList.isEmpty
                ? const Center(
                    child: Text('You are not enrolled on any courses...'),
                  )
                : RefreshIndicator(
                    color: kPrimaryColour,
                    onRefresh: ()  {
                      HapticFeedback.heavyImpact();
                      setState(() {
                        updateEnrolledList();
                        futureData =  getModels();
                      });
                      return futureData;
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: myList.length,
                          itemBuilder: (context, index) {
                            return EnrolledCourseCard(
                              displayList: myList,
                              index: index,
                              onBookmarkTapped: () {
                                setState(() {
                                  HapticFeedback.heavyImpact();
                                  myList[index].isSaved =
                                      !myList[index].isSaved;
                                  courseNotifier.currentCourse =
                                      myList[index];
                                  // Add the course as a favorite
                                  db.addSavedCourseSubCollection(
                                      index: index,
                                      displayList: myList,
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
                                courseNotifier.currentCourse = myList[index],
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
                          return ActiveCourseTile(
                            valueNotifier:
                                _setValueNotifier(displayOngoingList[index]),
                            courseName: displayOngoingList[index].courseName,
                            courseImage: displayOngoingList[index].courseImage,
                            remainingLessons:
                                displayOngoingList[index].remainingLessons,
                          );
                        }),
                  ));
        break;
      case 3:
        return Expanded(
            child: displayOngoingList.isEmpty
                ? const Center(
                    child: Text('No completed courses found...'),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: displayOngoingList.length,
                        itemBuilder: (context, index) {
                          return CompletedCourseTile(
                            courseName: displayOngoingList[index].courseName,
                            courseImage: displayOngoingList[index].courseImage,
                            remainingLessons:
                                displayOngoingList[index].remainingLessons,
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

  /// Initialise controllers and retrieve data from database
  @override
  void initState() {
    _animationController = AnimationController(vsync: this);
    courseNotifier = Provider.of<CourseNotifier>(context, listen: false);
    savedCoursesNotifier =
        Provider.of<SavedCoursesNotifier>(context, listen: false);
    userRef = FirebaseFirestore.instance.collection('Users').doc(userId);
    userNotifier = Provider.of<UserNotifier>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      myList = userNotifier.filterCoursesByIds(courseNotifier.courseList);
    });

    futureData = getModels();
    displayOngoingList = List.from(_myCourses);
    displayList = List.from(courseNotifier.courseList);

    super.initState();
  }

  /// Get courses pertaining to a specific user
  getMyCourses() async {
    await db.getCourses(courseNotifier)
        .then((value) {
      setState(() {
        myList = userNotifier.filterCoursesByIds(value);
      });
    });
    return myList;
  }


  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  ValueNotifier<double> _setValueNotifier(MyCourse course) {
    return _valueNotifier =
        ValueNotifier(calculateCompletionPercentage(course));
  }

  /// Build search bar tabs and course lists
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
                        padding:
                            const EdgeInsets.only(left: 25.0, right: 20),
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

  /// Default course listings for ongoing courses
  static final List<MyCourse> _myCourses = [
    MyCourse("Introduction to Programming", "assets/images/c2.jpg", 20, 15),
    MyCourse("Web Development with HTML/CSS", "assets/images/c2.jpg", 30, 20),
    MyCourse("Data Science Fundamentals", "assets/images/c2.jpg", 25, 5),
    MyCourse("Mobile App Development", "assets/images/c2.jpg", 40, 10),
  ];

  /// Returns the completion percentage based on the number of lessons in the course
  double calculateCompletionPercentage(MyCourse course) {
    double completionPercentage =
        (course.numLessons - course.remainingLessons) / course.numLessons * 100;
    return completionPercentage;
  }
}

/// Course model for ongoing courses
class MyCourse {
  String courseName;
  String courseImage;
  int remainingLessons;
  int numLessons;

  MyCourse(this.courseName, this.courseImage, this.numLessons,
      this.remainingLessons);
}
