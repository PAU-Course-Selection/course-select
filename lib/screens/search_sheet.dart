import 'package:course_select/controllers/home_page_notifier.dart';
import 'package:course_select/constants/constants.dart';
import 'package:course_select/models/saved_course_data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../controllers/course_notifier.dart';
import '../models/course_data_model.dart';
import '../routes/routes.dart';
import '../shared_widgets/mini_course_card.dart';
import '../utils/enums.dart';
import '../utils/firebase_data_management.dart';

/// [SearchSheet] is responsible for search filtering by subject area. skill level and using search terms in search boxes across the app.
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
  late CategorySearchFilter searchFilter;

  static late List<Course> displayAllList = [];
  static late List<Course> displayBeginnerList= [];
  static late List<Course> displayIntermediateList= [];
  static late List<Course> displayAdvancedList= [];
  static late List<Course> displayFrontedList= [];
  static late List<Course> displayBackendList= [];
  static late List<Course> displayProgrammingList= [];
  static late List<Course> displayDevOpsList= [];
  static late List<Course> displaySoftwareList= [];
  int duplicateCount = 0;

  get isAll {
    return searchFilter == CategorySearchFilter.all;
  }

  get isBeginner {
    return searchFilter == CategorySearchFilter.beginner;
  }

  get isIntermediate {
    return searchFilter == CategorySearchFilter.intermediate;
  }

  get isAdvanced {
    return searchFilter == CategorySearchFilter.advanced;
  }

  get isFrontend {
    return searchFilter == CategorySearchFilter.frontend;
  }

  get isBackend {
    return searchFilter == CategorySearchFilter.backend;
  }

  get isProgramming {
    return searchFilter == CategorySearchFilter.programming;
  }

  get isDevOps {
    return searchFilter == CategorySearchFilter.devOps;
  }

  get isSoftware {
    return searchFilter == CategorySearchFilter.software;
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
    setState(() {
      displayBeginnerList = courseNotifier.courseList
          .where((element) =>
      element.level.toLowerCase().
      contains(getSearchKeyword(CategorySearchFilter.beginner))&&
      element.courseName!.toLowerCase().contains(value.toLowerCase()) ||
          element.subjectArea!
              .toLowerCase()
              .contains(value.toLowerCase()) ||
          element.level!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }
  void updateIntermediateList(String value) {
    /// filter courses list
    setState(() {
      displayIntermediateList = courseNotifier.courseList
          .where((element) =>
      element.level.toLowerCase().
      contains(getSearchKeyword(CategorySearchFilter.intermediate))&&
      element.courseName!.toLowerCase().contains(value.toLowerCase()) ||
          element.subjectArea!
              .toLowerCase()
              .contains(value.toLowerCase()) ||
          element.level!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }
  void updateAdvancedList(String value) {
    /// filter courses list
    setState(() {
      displayAdvancedList = courseNotifier.courseList
          .where((element) =>
      element.level.toLowerCase().
      contains(getSearchKeyword(CategorySearchFilter.advanced))&&
      element.courseName!.toLowerCase().contains(value.toLowerCase()) ||
          element.subjectArea!
              .toLowerCase()
              .contains(value.toLowerCase()) ||
          element.level!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }
  void updateFrontendList(String value) {
    /// filter courses list
    setState(() {
      displayFrontedList = courseNotifier.courseList
          .where((element) =>
      element.subjectArea.toLowerCase().
      contains(getSearchKeyword(CategorySearchFilter.frontend))&&
      element.courseName.toLowerCase().contains(value.toLowerCase()) ||
          element.subjectArea
              .toLowerCase()
              .contains(value.toLowerCase()) ||
          element.level.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }
  void updateBackendList(String value) {
    /// filter courses list
    setState(() {
      displayBackendList = courseNotifier.courseList
          .where((element) =>
      element.subjectArea.toLowerCase().
      contains(getSearchKeyword(CategorySearchFilter.backend))&&
      element.courseName.toLowerCase().contains(value.toLowerCase()) ||
          element.subjectArea
              .toLowerCase()
              .contains(value.toLowerCase()) ||
          element.level.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }
  void updateProgrammingList(String value) {
    /// filter courses list
    setState(() {
      displayProgrammingList = courseNotifier.courseList
          .where((element) =>
      element.subjectArea.toLowerCase().
      contains(getSearchKeyword(CategorySearchFilter.programming))&&
      element.courseName.toLowerCase().contains(value.toLowerCase()) ||
          element.subjectArea
              .toLowerCase()
              .contains(value.toLowerCase()) ||
          element.level.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }
  void updateDevOpsList(String value) {
    /// filter courses list
    setState(() {
      displayDevOpsList = courseNotifier.courseList
          .where((element) =>
      element.subjectArea.toLowerCase().
      contains(getSearchKeyword(CategorySearchFilter.devOps))&&
      element.courseName.toLowerCase().contains(value.toLowerCase()) ||
          element.subjectArea
              .toLowerCase()
              .contains(value.toLowerCase()) ||
          element.level.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }
  void updateSoftwareList(String value) {
    /// filter courses list
    setState(() {
      displaySoftwareList = courseNotifier.courseList
          .where((element) =>
      element.subjectArea.toLowerCase().
      contains(getSearchKeyword(CategorySearchFilter.software))&&
      element.courseName.toLowerCase().contains(value.toLowerCase()) ||
          element.subjectArea
              .toLowerCase()
              .contains(value.toLowerCase()) ||
          element.level.toLowerCase().contains(value.toLowerCase()))
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
        result = 'all'.tr;
        break;
      case CategorySearchFilter.beginner:
        result = 'beginner'.tr;
        break;
      case CategorySearchFilter.intermediate:
        result = 'intermediate'.tr;
        break;
      case CategorySearchFilter.advanced:
        result = 'advanced'.tr;
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
    searchFilter = widget.categoryFilterKeyword;
    savedCoursesNotifier =
        Provider.of<SavedCoursesNotifier>(context, listen: false);
    _animationController = AnimationController(vsync: this);
    courseNotifier = Provider.of<CourseNotifier>(context, listen: false);
    //userNotifier = Provider.of<UserNotifier>(context, listen: false);
    initialiseLists();
    futureData = getModels();

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('searchFilter: $searchFilter');
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
                        'Search_for'.tr + getSearchKeyword(
                            searchFilter)+'courses'.tr,
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
                          switch(searchFilter){
                            case CategorySearchFilter.all:
                              updateAllList(value);
                              break;
                            case CategorySearchFilter.beginner:
                              updateBeginnerList(value);
                              break;
                            case CategorySearchFilter.intermediate:
                              updateIntermediateList(value);
                              break;
                            case CategorySearchFilter.advanced:
                              updateAdvancedList(value);
                              break;
                            case CategorySearchFilter.frontend:
                              updateFrontendList(value);
                              break;
                            case CategorySearchFilter.backend:
                              updateBackendList(value);
                              break;
                            case CategorySearchFilter.programming:
                              updateProgrammingList(value);
                              break;
                            case CategorySearchFilter.devOps:
                              updateDevOpsList(value);
                              break;
                            case CategorySearchFilter.software:
                              updateSoftwareList(value);
                              break;
                          }
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            hintText: 'eg. Data Science'.tr,
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
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: Text(
                        'categories'.tr,
                        style: const TextStyle(
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
                            children: [
                              CatPill(
                                  categoryName: 'Programming',
                                  categoryColour: const Color(0xffd5f1d3),
                                  categoryIcon: 'assets/icons/analysis.png',
                                onPressed: (){
                                    print('programming');
                                    setState(() {
                                      searchFilter = CategorySearchFilter.programming;
                                    });
                                },),
                              Flexible(
                                  child: CatPill(
                                      categoryName: 'Software Engineering',
                                      categoryColour: Color(0xffffd0ef),
                                      categoryIcon:
                                      'assets/icons/software.png', onPressed: (){
                                    setState(() {
                                      searchFilter = CategorySearchFilter.software;
                                    });

                                  },)),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              CatPill(
                                  categoryName: 'DevOps',
                                  categoryColour: Color(0xffffeeca),
                                  categoryIcon: 'assets/icons/devops.png', onPressed: (){
                                setState(() {
                                  searchFilter = CategorySearchFilter.devOps;
                                });

                              },),
                              CatPill(
                                  categoryName: 'Backend',
                                  categoryColour: Color(0xfffcfcc3),
                                  categoryIcon: 'assets/icons/security.png', onPressed: (){
                                setState(() {
                                  searchFilter = CategorySearchFilter.backend;
                                });

                              },),
                              Flexible(
                                  child: CatPill(
                                      categoryName: 'Frontend',
                                      categoryColour: Color(0xfff4e1fe),
                                      categoryIcon: 'assets/icons/ui.png', onPressed: (){
                                    setState(() {
                                      searchFilter = CategorySearchFilter.frontend;
                                    });

                                  },)),
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
                            ? Center(
                          child: Text('no_result'.tr),
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
                                  : isSoftware ? displaySoftwareList.length: isAdvanced? displayAdvancedList.length: displayAllList.length,
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
                                                    ? 'Added_to_saved_courses'.tr
                                                    : 'remove_save_courses'.tr,
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

  final Map<CategorySearchFilter, List<Course>> filterToList = {
    CategorySearchFilter.all: displayAllList,
    CategorySearchFilter.beginner: displayBeginnerList,
    CategorySearchFilter.intermediate: displayIntermediateList,
    CategorySearchFilter.advanced: displayAdvancedList,
    CategorySearchFilter.frontend: displayFrontedList,
    CategorySearchFilter.backend: displayBackendList,
    CategorySearchFilter.programming: displayProgrammingList,
    CategorySearchFilter.devOps: displayDevOpsList,
    CategorySearchFilter.software: displaySoftwareList,
  };

  /// Handles clicks on the filtered list of course to display course info
  _showInfoScreen(int index){
    final selectedList = filterToList[searchFilter];
    if (selectedList == null || index >= selectedList.length) {
      return;
    }
    courseNotifier.currentCourse = selectedList[index];
    Navigator.pushNamed(context, PageRoutes.courseInfo);
  }

  /// Allows course saving on the filtered lists
  _saveCourse(int index) {
    var displayList, item;
    switch (searchFilter) {
      case CategorySearchFilter.all:
        displayList = displayAllList;
        item = displayList[index];
        break;
      case CategorySearchFilter.beginner:
        displayList = displayBeginnerList;
        item = displayList[index];
        break;
      case CategorySearchFilter.intermediate:
        displayList = displayIntermediateList;
        item = displayList[index];
        break;
      case CategorySearchFilter.advanced:
        displayList = displayAdvancedList;
        item = displayList[index];
        break;
      case CategorySearchFilter.frontend:
        displayList = displayFrontedList;
        item = displayList[index];
        break;
      case CategorySearchFilter.backend:
        displayList = displayBackendList;
        item = displayList[index];
        break;
      case CategorySearchFilter.programming:
        displayList = displayProgrammingList;
        item = displayList[index];
        break;
      case CategorySearchFilter.devOps:
        displayList = displayDevOpsList;
        item = displayList[index];
        break;
      case CategorySearchFilter.software:
        displayList = displaySoftwareList;
        item = displayList[index];
        break;
    }
    setState(() {
      item.isSaved = !item.isSaved;
    });
    courseNotifier.currentCourse = item;
    db.addSavedCourseSubCollection(
        index: index,
        displayList: displayList,
        duplicateCount: duplicateCount,
        savedCourses: savedCoursesNotifier,
        courseNotifier: courseNotifier);
  }

}
/// [CatPill] encapsulates the UI elements of the category pills to filter courses
class CatPill extends StatelessWidget {
  final String categoryName;
  final Color categoryColour;
  final String categoryIcon;
  final Function onPressed;

  const CatPill({
    Key? key,
    required this.categoryName,
    required this.categoryColour,
    required this.categoryIcon, required this.onPressed,
  }) : super(key: key);

  /// Builds ui elements for the search page
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: kSaraLightPink,
      onTap: ()=> onPressed.call(),
      child: Padding(
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
      ),
    );
  }
}
