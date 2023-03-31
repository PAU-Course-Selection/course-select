import 'package:course_select/controllers/home_page_notifier.dart';
import 'package:course_select/constants/constants.dart';
import 'package:course_select/models/saved_course_data_model.dart';
import 'package:course_select/shared_widgets/courses_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../controllers/course_notifier.dart';
import '../models/course_data_model.dart';
import '../routes/routes.dart';
import '../shared_widgets/mini_course_card.dart';
import '../utils/firebase_data_management.dart';

class SearchSheet extends StatefulWidget {
  final String filter;
  const SearchSheet({Key? key,required this.filter}) : super(key: key);

  @override
  State<SearchSheet> createState() => _SearchSheetState();
}

class _SearchSheetState extends State<SearchSheet>
    with SingleTickerProviderStateMixin {
  DatabaseManager db = DatabaseManager();
  HomePageNotifier homePageNotifier = HomePageNotifier();
  late final CourseNotifier courseNotifier;
  late final SavedCoursesNotifier savedCoursesNotifier;
  //late List<Course> savedList = [];

  //late final UserNotifier userNotifier;
  late Future futureData;

  late List<Course> displayList;
  int duplicateCount = 0;

  void updateList(String value) {
    /// filter courses list
    setState(() {
      displayList = courseNotifier.courseList
          .where((element) =>
      element.courseName!.toLowerCase().contains(value.toLowerCase())
          || element.subjectArea!.toLowerCase().contains(value.toLowerCase())
          || element.level!.toLowerCase().contains(value.toLowerCase())
      )
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
    savedCoursesNotifier = Provider.of<SavedCoursesNotifier>(context, listen: false);
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
              padding: const EdgeInsets.all(0),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Padding(
                      padding: const EdgeInsets.only(left: 25.0, top: 25),
                      child: Text(
                        'Search for ${widget.filter} courses',
                        style: const TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto'),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: TextField(
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
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 25.0),
                      child: Text(
                        'Categories',
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto'),
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Expanded(
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

                                      courseNotifier.currentCourse = courseNotifier.courseList[index];
                                      db.addSavedCourseSubCollection(index: index, displayList: displayList,
                                          duplicateCount: duplicateCount, savedCourses: savedCoursesNotifier, courseNotifier: courseNotifier);

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          elevation: 1,
                                          behavior:
                                          SnackBarBehavior.fixed,
                                          backgroundColor: kKindaGreen,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  5)),
                                          content: Center(
                                              child: Text(
                                                displayList[index].isSaved
                                                    ? 'Added to saved courses'
                                                    : 'Removed from saved courses',
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                    FontWeight.bold),
                                              )),
                                          duration:
                                          const Duration(seconds: 1),
                                        ),
                                      );
                                    });
                                  }, onCardPressed: (){
                                  courseNotifier.currentCourse = courseNotifier.courseList[index];
                                  Navigator.pushNamed(context, PageRoutes.courseInfo);
                                },);
                              }),
                        )),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
