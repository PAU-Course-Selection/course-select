import 'package:course_select/controllers/home_page_notifier.dart';
import 'package:course_select/constants/constants.dart';
import 'package:course_select/models/saved_course_data_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../controllers/course_notifier.dart';
import '../models/course_data_model.dart';
import '../routes/routes.dart';
import '../shared_widgets/mini_course_card.dart';
import '../utils/enums.dart';
import '../utils/firebase_data_management.dart';

class SearchSheet extends StatefulWidget {
  final CategorySearchFilter categoryFilterKeyword;

  const SearchSheet({Key? key, required this.categoryFilterKeyword})
      : super(key: key);

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
  late final AnimationController _animationController;

  late List<Course> displayAllList;
  late List<Course> displayBeginnerList;
  late List<Course> displayIntermediateList;
  late List<Course> displayAdvancedList;
  late List<Course> displayFrontedList;
  late List<Course> displayBackendList;
  late List<Course> displayProgrammingList;
  late List<Course> displayDevOpsList;
  late List<Course> displaySoftwareList;
  int duplicateCount = 0;

  get isAll {
    return widget.categoryFilterKeyword == CategorySearchFilter.all;
  }

  get isBeginner {
    return widget.categoryFilterKeyword == CategorySearchFilter.beginner;
  }

  get isIntermediate {
    return widget.categoryFilterKeyword == CategorySearchFilter.intermediate;
  }

  get isAdvanced {
    return widget.categoryFilterKeyword == CategorySearchFilter.advanced;
  }

  get isFrontend {
    return widget.categoryFilterKeyword == CategorySearchFilter.frontend;
  }

  get isBackend {
    return widget.categoryFilterKeyword == CategorySearchFilter.backend;
  }

  get isProgramming {
    return widget.categoryFilterKeyword == CategorySearchFilter.programming;
  }

  get isDevOps {
    return widget.categoryFilterKeyword == CategorySearchFilter.devOps;
  }

  get isSoftware {
    return widget.categoryFilterKeyword == CategorySearchFilter.software;
  }

  void initialiseLists() {
    displayAllList = List.from(courseNotifier.courseList);

    displayBeginnerList = List.from(courseNotifier.courseList.where((element) =>
        element.level
            .toLowerCase()
            .contains(getSearchKeyword(CategorySearchFilter.beginner))));

    displayIntermediateList = List.from(courseNotifier.courseList.where(
            (element) =>
            element.level
                .toLowerCase()
                .contains(
                getSearchKeyword(CategorySearchFilter.intermediate))));

    displayAdvancedList = List.from(courseNotifier.courseList.where((element) =>
        element.level
            .toLowerCase()
            .contains(getSearchKeyword(CategorySearchFilter.advanced))));

    displayFrontedList = List.from(courseNotifier.courseList.where((element) =>
        element.subjectArea
            .toLowerCase()
            .contains(getSearchKeyword(CategorySearchFilter.frontend))));

    displayBackendList = List.from(courseNotifier.courseList.where((element) =>
        element.subjectArea
            .toLowerCase()
            .contains(getSearchKeyword(CategorySearchFilter.backend))));

    displayProgrammingList = List.from(courseNotifier.courseList.where(
            (element) =>
            element.subjectArea
                .toLowerCase()
                .contains(getSearchKeyword(CategorySearchFilter.programming))));

    displayDevOpsList = List.from(courseNotifier.courseList.where((element) =>
        element.subjectArea
            .toLowerCase()
            .contains(getSearchKeyword(CategorySearchFilter.devOps))));

    displaySoftwareList = List.from(courseNotifier.courseList.where((element) =>
        element.subjectArea
            .toLowerCase()
            .contains(getSearchKeyword(CategorySearchFilter.software))));
  }

  void updateAllList(String value) {
    /// filter courses list
    print(value);
    setState(() {
      displayAllList = courseNotifier.courseList
          .where((element) =>
      element.courseName!.toLowerCase().contains(value.toLowerCase()) ||
          element.subjectArea!
              .toLowerCase()
              .contains(value.toLowerCase()) ||
          element.level!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  void updateBeginnerList(String value) {
    /// filter courses list
    print(value);
    setState(() {
      displayBeginnerList
          .where((element) =>
      element.courseName!.toLowerCase().contains(value.toLowerCase()) ||
          element.subjectArea!
              .toLowerCase()
              .contains(value.toLowerCase()) ||
          element.level!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  Future getModels() {
    //db.getUsers(userNotifier);
    return db.getCourses(courseNotifier);
  }

  String getSearchKeyword(CategorySearchFilter filter) {
    String result;
    switch (filter) {
      case CategorySearchFilter.all:
        result = 'all';
        break;
      case CategorySearchFilter.beginner:
        result = 'beginner';
        break;
      case CategorySearchFilter.intermediate:
        result = 'intermediate';
        break;
      case CategorySearchFilter.advanced:
        result = 'advanced';
        break;
      case CategorySearchFilter.frontend:
        result = 'frontend';
        break;
      case CategorySearchFilter.backend:
        result = 'backend';
        break;
      case CategorySearchFilter.programming:
        result = 'programming';
        break;
      case CategorySearchFilter.devOps:
        result = 'devOps';
        break;
      case CategorySearchFilter.software:
        result = 'software';
        break;
    }
    return result;
  }

  @override
  void initState() {
    savedCoursesNotifier =
        Provider.of<SavedCoursesNotifier>(context, listen: false);
    _animationController = AnimationController(vsync: this);
    courseNotifier = Provider.of<CourseNotifier>(context, listen: false);
    //userNotifier = Provider.of<UserNotifier>(context, listen: false);
    futureData = getModels();
    initialiseLists();

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
                        'Search for ${getSearchKeyword(
                            widget.categoryFilterKeyword)} courses',
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
                          updateAllList(value);
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            hintText: 'eg. Data Science',
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
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: Column(
                        children: [
                          Row(
                            children: const [
                              CatPill(
                                  categoryName: 'Programming',
                                  categoryColour: Color(0xffd5f1d3),
                                  categoryIcon: 'assets/icons/analysis.png'),
                              Flexible(
                                  child: CatPill(
                                      categoryName: 'Software Engineering',
                                      categoryColour: Color(0xffffd0ef),
                                      categoryIcon:
                                      'assets/icons/software.png')),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: const [
                              CatPill(
                                  categoryName: 'DevOps',
                                  categoryColour: Color(0xffffeeca),
                                  categoryIcon: 'assets/icons/devops.png'),
                              CatPill(
                                  categoryName: 'Backend',
                                  categoryColour: Color(0xfffcfcc3),
                                  categoryIcon: 'assets/icons/security.png'),
                              Flexible(
                                  child: CatPill(
                                      categoryName: 'Frontend',
                                      categoryColour: Color(0xfff4e1fe),
                                      categoryIcon: 'assets/icons/ui.png')),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Expanded(
                        child: isAll && displayAllList.isEmpty ||
                            isBeginner && displayBeginnerList.isEmpty||isIntermediate && displayIntermediateList.isEmpty||
                            isAdvanced && displayAdvancedList.isEmpty||isFrontend && displayFrontedList.isEmpty||
                            isBackend && displayBackendList.isEmpty ||isDevOps && displayDevOpsList.isEmpty||
                            isProgramming && displayProgrammingList.isEmpty||isSoftware && displaySoftwareList.isEmpty
                            ? const Center(
                          child: Text('No results found...'),
                        )
                            : Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25.0),
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: isAll
                                  ? displayAllList.length
                                  : isBeginner ? displayBeginnerList.length
                                  : isIntermediate ? displayIntermediateList
                                  .length
                                  : isFrontend ? displayFrontedList.length
                                  : isBackend ? displayBackendList.length
                                  : isProgramming ? displayProgrammingList
                                  .length
                                  : isDevOps
                                  ? displayDevOpsList.length
                                  : isSoftware ? displaySoftwareList.length: displayAllList.length,
                              itemBuilder: (context, index) {
                                return MiniCourseCard(
                                  displayList: isAll
                                      ? displayAllList
                                      : isBeginner? displayBeginnerList: isIntermediate? displayIntermediateList
                                  :isAdvanced? displayAdvancedList: isProgramming? displayProgrammingList: isDevOps?displayDevOpsList
                                  :isSoftware? displaySoftwareList: isBackend? displayBackendList: isFrontend? displayFrontedList: displayAllList,
                                  index: index,
                                  onBookmarkTapped: () {
                                    HapticFeedback.heavyImpact();
                                    setState(() {
                                      _saveCourse(index);

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
                                                displayAllList[index].isSaved||
                                                displayBeginnerList[index].isSaved||displayIntermediateList[index].isSaved||
                                              displayAdvancedList[index].isSaved||displayFrontedList[index].isSaved||
                                              displayBackendList[index].isSaved || displayDevOpsList[index].isSaved||
                                              displayProgrammingList[index].isSaved||displaySoftwareList[index].isSaved
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
                                  },
                                  onCardPressed: () {
                                    _showInfoScreen(index);
                                  },
                                );
                              }),
                        )),
                  ],
                ),
              ),
            );
          }),
    );
  }

  _showInfoScreen(int index){

    switch(widget.categoryFilterKeyword){
      case CategorySearchFilter.all:
        courseNotifier.currentCourse =
        displayAllList[index];
        Navigator.pushNamed(
            context, PageRoutes.courseInfo);
        break;
      case CategorySearchFilter.beginner:
        courseNotifier.currentCourse =
        displayBeginnerList[index];
        Navigator.pushNamed(
            context, PageRoutes.courseInfo);
        break;
      case CategorySearchFilter.intermediate:
        courseNotifier.currentCourse =
        displayIntermediateList[index];
        Navigator.pushNamed(
            context, PageRoutes.courseInfo);
        break;
      case CategorySearchFilter.advanced:
        courseNotifier.currentCourse =
        displayAdvancedList[index];
        Navigator.pushNamed(
            context, PageRoutes.courseInfo);
        break;
      case CategorySearchFilter.frontend:
        courseNotifier.currentCourse =
        displayFrontedList[index];
        Navigator.pushNamed(
            context, PageRoutes.courseInfo);
        break;
      case CategorySearchFilter.backend:
        courseNotifier.currentCourse =
        displayBackendList[index];
        Navigator.pushNamed(
            context, PageRoutes.courseInfo);
        break;
      case CategorySearchFilter.programming:
        courseNotifier.currentCourse =
        displayProgrammingList[index];
        Navigator.pushNamed(
            context, PageRoutes.courseInfo);
        break;
      case CategorySearchFilter.devOps:
        courseNotifier.currentCourse =
        displayDevOpsList[index];
        Navigator.pushNamed(
            context, PageRoutes.courseInfo);
        break;
      case CategorySearchFilter.software:
        courseNotifier.currentCourse =
        displaySoftwareList[index];
        Navigator.pushNamed(
            context, PageRoutes.courseInfo);
        break;
    }

  }

  _saveCourse(int index) {
    var allItem = displayAllList[index];
    var beginnerItem = displayBeginnerList[index];
    var intermediateItem = displayIntermediateList[index];
    var advancedItem = displayAdvancedList[index];
    var frontendItem = displayFrontedList[index];
    var backendItem = displayBackendList[index];
    var programmingItem = displayProgrammingList[index];
    var devOpsItem = displayDevOpsList[index];
    var softwareItem = displaySoftwareList[index];

    switch (widget.categoryFilterKeyword) {
      case CategorySearchFilter.all:
        allItem.isSaved = !allItem.isSaved;
        courseNotifier.currentCourse = allItem;
        db.addSavedCourseSubCollection(
            index: index,
            displayList: displayAllList,
            duplicateCount: duplicateCount,
            savedCourses: savedCoursesNotifier,
            courseNotifier: courseNotifier);
        break;
      case CategorySearchFilter.beginner:
        beginnerItem.isSaved = !beginnerItem.isSaved;
        courseNotifier.currentCourse = beginnerItem;
        db.addSavedCourseSubCollection(
            index: index,
            displayList: displayBeginnerList,
            duplicateCount: duplicateCount,
            savedCourses: savedCoursesNotifier,
            courseNotifier: courseNotifier);
        break;
      case CategorySearchFilter.intermediate:
        intermediateItem.isSaved = !intermediateItem.isSaved;
        courseNotifier.currentCourse = intermediateItem;
        db.addSavedCourseSubCollection(
            index: index,
            displayList: displayIntermediateList,
            duplicateCount: duplicateCount,
            savedCourses: savedCoursesNotifier,
            courseNotifier: courseNotifier);
        break;
      case CategorySearchFilter.advanced:
        advancedItem.isSaved = !advancedItem.isSaved;
        courseNotifier.currentCourse = advancedItem;
        db.addSavedCourseSubCollection(
            index: index,
            displayList: displayAdvancedList,
            duplicateCount: duplicateCount,
            savedCourses: savedCoursesNotifier,
            courseNotifier: courseNotifier);
        break;
      case CategorySearchFilter.frontend:
        frontendItem.isSaved = !frontendItem.isSaved;
        courseNotifier.currentCourse = frontendItem;
        db.addSavedCourseSubCollection(
            index: index,
            displayList: displayFrontedList,
            duplicateCount: duplicateCount,
            savedCourses: savedCoursesNotifier,
            courseNotifier: courseNotifier);
        break;
      case CategorySearchFilter.backend:
        backendItem.isSaved = !backendItem.isSaved;
        courseNotifier.currentCourse = backendItem;
        db.addSavedCourseSubCollection(
            index: index,
            displayList: displayBackendList,
            duplicateCount: duplicateCount,
            savedCourses: savedCoursesNotifier,
            courseNotifier: courseNotifier);
        break;
      case CategorySearchFilter.programming:
        programmingItem.isSaved = !programmingItem.isSaved;
        courseNotifier.currentCourse = programmingItem;
        db.addSavedCourseSubCollection(
            index: index,
            displayList: displayProgrammingList,
            duplicateCount: duplicateCount,
            savedCourses: savedCoursesNotifier,
            courseNotifier: courseNotifier);
        break;
      case CategorySearchFilter.devOps:
        devOpsItem.isSaved = !devOpsItem.isSaved;
        courseNotifier.currentCourse = devOpsItem;
        db.addSavedCourseSubCollection(
            index: index,
            displayList: displayDevOpsList,
            duplicateCount: duplicateCount,
            savedCourses: savedCoursesNotifier,
            courseNotifier: courseNotifier);
        break;
      case CategorySearchFilter.software:
        softwareItem.isSaved = !softwareItem.isSaved;
        courseNotifier.currentCourse = softwareItem;
        db.addSavedCourseSubCollection(
            index: index,
            displayList: displaySoftwareList,
            duplicateCount: duplicateCount,
            savedCourses: savedCoursesNotifier,
            courseNotifier: courseNotifier);
        break;
    }
  }
}

class CatPill extends StatelessWidget {
  final String categoryName;
  final Color categoryColour;
  final String categoryIcon;

  const CatPill({
    Key? key,
    required this.categoryName,
    required this.categoryColour,
    required this.categoryIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 5.0),
      child: Container(
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
            color: categoryColour,
            borderRadius: const BorderRadius.all(Radius.circular(15.0))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Image.asset(
                  categoryIcon,
                  width: 24,
                  height: 20,
                )),
            Text(
              categoryName,
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
