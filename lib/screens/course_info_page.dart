import 'package:cached_network_image/cached_network_image.dart';
import 'package:course_select/controllers/course_notifier.dart';
import 'package:course_select/constants/constants.dart';
import 'package:course_select/controllers/home_page_notifier.dart';
import 'package:course_select/controllers/lesson_notifier.dart';
import 'package:course_select/models/user_data_model.dart';
import 'package:course_select/shared_widgets/android_confirmation_dialog.dart';
import 'package:course_select/shared_widgets/android_limitation_dialog.dart';
import 'package:course_select/shared_widgets/gradient_button.dart';
import 'package:course_select/shared_widgets/video_player.dart';
import 'package:course_select/utils/color_picker.dart';
import 'package:course_select/utils/firebase_data_management.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io' show Platform;
import '../controllers/user_notifier.dart';
import '../models/course_data_model.dart';
import '../routes/routes.dart';
import '../shared_widgets/course_card.dart';
import '../shared_widgets/ios_confirmation_dialog.dart';
import '../shared_widgets/ios_limitation_dialog.dart';
import '../utils/enums.dart';

class CourseInfoPage extends StatefulWidget {
  const CourseInfoPage({
    Key? key,
  }) : super(key: key);

  @override
  State<CourseInfoPage> createState() => _CourseInfoPageState();
}

class _CourseInfoPageState extends State<CourseInfoPage> {
  late CourseNotifier _courseNotifier;
  late UserNotifier _userNotifier;
  late HomePageNotifier _homePageNotifier;
  late LessonNotifier _lessonNotifier;
  final DatabaseManager _db = DatabaseManager();
  late List<UserModel> classmates = [];
  late List recommendations;
  late int numLessons;
  Image img = Image.asset('assets/images/c2.jpg');
  String videoUrl = '';
  var userCourses;

  final ScrollController _controller =
      ScrollController(initialScrollOffset: 60.w);

  @override
  void initState() {
    super.initState();
    _courseNotifier = Provider.of<CourseNotifier>(context, listen: false);
    numLessons = _courseNotifier.currentCourse.totalLessons;
    _homePageNotifier = Provider.of<HomePageNotifier>(context, listen: false);
    _userNotifier = Provider.of<UserNotifier>(context, listen: false);
    _lessonNotifier = Provider.of<LessonNotifier>(context, listen: false);
    videoUrl = _courseNotifier.currentCourse.media[0];
    getNumLessons();
    getClassmates();
    userCourses = _userNotifier.getCourseIds();

    recommendations = getRecommendation(
        _courseNotifier.courseList, _courseNotifier.currentCourse.prereqs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Course Info',
          style: kHeadlineMedium,
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        height: 50,
        margin: const EdgeInsets.only(left: 25, right: 25),
        child: _conditionalBottomButton(),
      ),
      body: _courseInfo(),
    );
  }

  getClassmates() async {
    await _db
        .getClassmates(_courseNotifier.currentCourse.courseId, _userNotifier)
        .then((value) {
      setState(() {
        classmates = value;
      });
    });
  }

  List<Course> getRecommendation(List<Course> courses, List prereqs) {
    List<Course> filteredCourses = [];
    try {
      for (var course in courses) {
        //print(course.courseId);
        if (prereqs.contains(course.courseId)) {
          filteredCourses.add(course);
        }
      }
    } catch (e) {
      print(e);
    }
    setState(() {});
    print(filteredCourses);
    return filteredCourses;
  }

  getNumLessons() async {
    await _db.getTotalLessons(_courseNotifier).then((value) {
      setState(() {
        numLessons = value;
      });
    });
  }

  String formatPrerequisites(
      List prerequisites, List<Course> courses, List enrolledCourses) {
    final reqCourseIds = <String>{};

    for (final course in courses) {
      // If the course ID is in the list of prerequisites and not in the enrolled course list,
      // add the course ID to the set of required course IDs.
      if (prerequisites.contains(course.courseId) &&
          !enrolledCourses.contains(course.courseId)) {
        reqCourseIds.add(course.courseId);
      }
    }
    // Initialize a list to store the names of the required courses.
    final reqCourses = <String>[];

    // Iterate through each required course ID in the set of required course IDs.
    for (final courseId in reqCourseIds) {
      // Find the course with the corresponding course ID and add its name to the list of required course names.
      final course = courses.firstWhere((c) => c.courseId == courseId);
      reqCourses.add(course.courseName);
    }

    // If there are no required courses, return an empty string.
    if (reqCourses.isEmpty) {
      return '';
    }

    // If there is only one required course, return its name.
    if (reqCourses.length == 1) {
      return reqCourses[0];
    }

    // If there are multiple required courses, join their names with 'and'.
    final lastCourse = reqCourses.removeLast();
    final formattedCourses = reqCourses.join(', ') + ', and ' + lastCourse;

    return formattedCourses;
  }

  Widget _conditionalBottomButton() {
    var preReqs = formatPrerequisites(_courseNotifier.currentCourse.prereqs,
        _courseNotifier.courseList, _userNotifier.userCourseIds);
    if (userCourses.contains(_courseNotifier.currentCourse.courseId)) {
      return GradientButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              elevation: 1,
              behavior: SnackBarBehavior.fixed,
              backgroundColor: kKindaGreen,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              content: const Center(
                  child: Text(
                "Yayy! Course Completed!",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.0,
                    fontFamily: "Robots",
                    fontWeight: FontWeight.bold),
              )),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        buttonText: 'Complete Course',
      );
    } else {
      return GradientButton(
        onPressed: () {
          if (_db.getTotalWeeklyHours(
                      _userNotifier.userCourseIds, _courseNotifier) +
                  _courseNotifier.currentCourse.hoursPerWeek >
              19) {
            _courseNotifier.isHourlyLimitReached = true;
          }
          // _homePageNotifier.isStateChanged = true;
          final skillLevels = {0: 'beginner', 1: 'intermediate', 2: 'advanced'};
          final userLevel = _userNotifier.studentLevel;
          final courseLevel = _courseNotifier.currentCourse.level.toLowerCase();
          final courseLevelIndex = skillLevels.entries
              .firstWhere((entry) => entry.value == courseLevel)
              .key;
          final courseLevelString = skillLevels[courseLevelIndex];
          bool isMatching = false;
          print('courseLevelString: $courseLevelString');
          print('skillLevels[userLevel]: ${skillLevels[userLevel]}');
          if (courseLevelIndex <= userLevel) {
            isMatching = true;
            print('isMatching $isMatching');
          }
          showDialog(
            context: context,
            builder: (BuildContext context) {
              if (Platform.isAndroid) {
                return androidDialog(
                  courseNotifier: _courseNotifier,
                  preReqs: preReqs,
                  isMatching: isMatching,
                  db: _db,
                  userNotifier: _userNotifier,
                  homePageNotifier: _homePageNotifier,
                );
              } else {
                return iosDialog(
                  courseNotifier: _courseNotifier,
                  preReqs: preReqs,
                  isMatching: isMatching,
                  db: _db,
                  userNotifier: _userNotifier,
                  homePageNotifier: _homePageNotifier, lessonNotifier: _lessonNotifier,
                );
              }
            },
          );
        },
        buttonText: 'Enroll',
      );
    }
  }

  Widget androidDialog({
    required CourseNotifier courseNotifier,
    required String preReqs,
    required bool isMatching,
    required DatabaseManager db,
    required UserNotifier userNotifier,
    required HomePageNotifier homePageNotifier,
  }) {
    if (_courseNotifier.isHourlyLimitReached == true) {
      return const AndroidLimitationDialog(
        preReqs: '',
        message:
            'Enrolling on this course will cause you to exceed the 20 hours weekly limit. Please complete some courses before adding more.',
      );
    }
    if (preReqs.isNotEmpty && !isMatching) {
      return AndroidLimitationDialog(
        preReqs: preReqs,
        message:
            'Based on your skill level and this course\'s prerequisite requirements, '
            'we recommend that you take ',
      );
    } else {
      return AndroidConfirmationDialog(
        courseNotifier: courseNotifier,
        preReqs: isMatching && preReqs.isNotEmpty
            ? 'with prerequisites: $preReqs'
            : preReqs,
        db: db,
        userNotifier: userNotifier,
        homePageNotifier: homePageNotifier, lessonNotifier: _lessonNotifier,
      );
    }
  }

  Widget iosDialog({
    required CourseNotifier courseNotifier,
    required String preReqs,
    required bool isMatching,
    required DatabaseManager db,
    required UserNotifier userNotifier,
    required HomePageNotifier homePageNotifier,
    required LessonNotifier lessonNotifier,
  }) {
    if (_courseNotifier.isHourlyLimitReached == true) {
      return IOSLimitationDialog(
        preReqs: '',
        message:
            'Enrolling on this course will cause you to exceed the 20 hours weekly limit. Please complete some courses before adding more.',
        onTap: _setConflictState,
      );
    }
    if (_userNotifier.isConflict == true) {
      return IOSLimitationDialog(
        preReqs: '',
        message:
        'Course conflicts with enrolled lessons.',
        onTap: _setConflictState,
      );
    }
    if (preReqs.isNotEmpty && !isMatching) {
      return IOSLimitationDialog(
        preReqs: preReqs,
        message:
            'Based on your skill level and this course\'s prerequisite requirements, '
            'we recommend that you take ',
        onTap: _setConflictState,
      );
    } else {
      return IOSConfirmationDialog(
        courseNotifier: courseNotifier,
        preReqs: isMatching && preReqs.isNotEmpty
            ? ' with prerequisites: $preReqs'
            : preReqs,
        db: db,
        userNotifier: userNotifier,
        homePageNotifier: homePageNotifier, lessonNotifier: lessonNotifier,
      );
    }
  }

   _setConflictState(){
    Navigator.pop(context);
    setState(() {
      _userNotifier.isConflict =false;
      print('called');
      _userNotifier.getCourseIds();
      print(_userNotifier.isConflict);
    });
   }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userNotifier = Provider.of<UserNotifier>(context);
    _userNotifier.getStudentLevel();
  }

  Widget _courseInfo() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //COURSE NAME
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              width: 400,
              child: Animate(
                child: Text(
                  _courseNotifier.currentCourse.courseName,
                  style: TextStyle(
                      fontSize: 32.00,
                      fontFamily: 'Roboto',
                      color: kDeepGreen,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
              ).fadeIn(duration: 1.seconds),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    color: ColourPicker()
                        .selectSkillColor(_courseNotifier.currentCourse.level),
                    borderRadius: BorderRadius.all(
                      Radius.circular(25.0),
                    )),
                child: Text(
                  _courseNotifier.currentCourse.level,
                  style: const TextStyle(),
                )),
          ),

          //MEDIA LIST
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 300.h,
              width: double.infinity,
              child: ListView.builder(
                controller: _controller,
                scrollDirection: Axis.horizontal,
                itemCount: _courseNotifier.currentCourse.media.length,
                itemBuilder: (context, index) {
                  return _photoVideoView(index);
                },
              ),
            ),
          ),

          //ROW WITH SHARE BUTTON
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  InfoPill(
                      icon: 'assets/icons/hourglass.png',
                      text: _hoursPerWeek(),
                      bgColour: const Color(0xffffeeca)),
                  const SizedBox(
                    width: 8,
                  ),
                  InfoPill(
                      icon: 'assets/icons/lesson.png',
                      text: '$numLessons Lessons',
                      bgColour: const Color(0xffd5f1d3)),
                  const SizedBox(
                    width: 10,
                  ),
                  FloatingActionButton(
                    backgroundColor: kSaraLightPink,
                    foregroundColor: kTeal,
                    elevation: 0,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onPressed: () => Share.share(
                        "Check out the ${_courseNotifier.currentCourse.courseName} course in the Study Sprint app."),
                    child: const Icon(Icons.share),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
            child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                    color: kGreyBackground,
                    borderRadius: BorderRadius.circular(16.0)),
                child: const ReadMoreText(
                  'Flutter is Google’s mobile UI open source framework to build high-quality native (super fast) interfaces for iOS and Android apps with the unified codebase.',
                  trimLines: 2,
                  colorClickableText: Colors.pink,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: 'Show more',
                  trimExpandedText: '..Show less',
                  moreStyle:
                      TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  lessStyle:
                      TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                )),
          ),
          //Classmates Heading

          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Text(
              "Classmates",
              style: kHeadlineMedium,
            ),
          ),
          //Classmates Box
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
              child: Container(
                  height: 120.h,
                  width: double.infinity,
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: kGreyBackground,
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: classmates.isNotEmpty
                      ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: classmates.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.white,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(75.0),
                                        child: CachedNetworkImage(
                                          height: 60.0,
                                          width: 60.0,
                                          fit: BoxFit.cover,
                                          imageUrl: classmates[index].avatar!,
                                          placeholder: (context, url) {
                                            return const CircularProgressIndicator();
                                          },
                                          errorWidget: (context, url, error) =>
                                              const Icon(
                                            Icons.person,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      )),
                                  Text(
                                    classmates[index].displayName!,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                            );
                          })
                      : const Center(
                          child: Text('No one has enrolled on this course yet'),
                        ))),
          recommendations.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 25.0, bottom: 10, top: 10),
                      child: Text(
                        "Recommended",
                        style: kHeadlineMedium,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: SizedBox(
                        height: 250.h,
                        width: double.infinity,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: recommendations.length,
                            itemBuilder: (context, index) {
                              var courseName =
                                  recommendations[index].courseName;
                              return GestureDetector(
                                onTap: () {
                                  _courseNotifier.currentCourse =
                                      recommendations[index];
                                  Navigator.pushNamed(
                                      context, PageRoutes.courseInfo);
                                },
                                child: CourseCard(
                                  courseTitle: courseName.length > 30
                                      ? courseName.substring(0, 30) + '...'
                                      : courseName,
                                  courseImage: recommendations[index].media[1],
                                  subjectArea:
                                      recommendations[index].subjectArea,
                                  hoursPerWeek: recommendations[index].duration,
                                  numLessons:
                                      recommendations[index].totalLessons,
                                ),
                              );
                            }),
                      ),
                    ),
                  ],
                )
              : Container(),
          const SizedBox(
            height: 200,
          )
        ],
      ),
    );
  }

  String _hoursPerWeek() {
    String hpw = _courseNotifier.currentCourse.hoursPerWeek.toString();
    return "$hpw Weeks ";
  }

  Widget _photoVideoView(int index) {
    var type = '';
    if (index == 0) {
      type = "video";
    } else {
      type = "photo";
    }

    switch (type) {
      case "video":
        return _courseVideo();
      case "photo":
        return _courseImage(index);
      default:
        return Container();
    }
  }

  Widget _courseImage(int index) {
    var current = _courseNotifier.currentCourse;

    Padding courseMedia = Padding(
      padding: const EdgeInsets.all(16.0),
      child: AspectRatio(
        aspectRatio: 300 / 220,
        child: Material(
          borderRadius: BorderRadius.circular(25.0),
          elevation: 5,
          clipBehavior: Clip.hardEdge,
          // elevation: 20,

          child: CachedNetworkImage(
            imageUrl: current.media[index],
          ),
        ),
      ),
    );
    return courseMedia;
  }

  Widget _courseVideo() {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: AspectRatio(
          aspectRatio: 370 / 250,
          child: Material(
            borderRadius: BorderRadius.circular(25.0),
            clipBehavior: Clip.hardEdge,
            elevation: 5,
            child: CourseVideoPlayer(videoPath: videoUrl),
          ),
        ));
  }
}

class InfoPill extends StatelessWidget {
  final String icon;
  final String text;
  final Color bgColour;

  const InfoPill({
    Key? key,
    required this.icon,
    required this.text,
    required this.bgColour,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
            color: bgColour,
            borderRadius: const BorderRadius.all(Radius.circular(25.0))),
        child: Row(
          children: [
            Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Image.asset(
                  icon,
                  width: 24,
                  height: 20,
                )),
            Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
