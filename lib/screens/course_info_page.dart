import 'package:cached_network_image/cached_network_image.dart';
import 'package:course_select/controllers/course_notifier.dart';
import 'package:course_select/constants/constants.dart';
import 'package:course_select/controllers/home_page_notifier.dart';
import 'package:course_select/models/user_data_model.dart';
import 'package:course_select/shared_widgets/gradient_button.dart';
import 'package:course_select/shared_widgets/video_player.dart';
import 'package:course_select/utils/firebase_data_management.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io' show Platform;
import '../controllers/user_notifier.dart';
import '../models/course_data_model.dart';
import '../routes/routes.dart';
import '../shared_widgets/course_card.dart';

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
  final DatabaseManager _db = DatabaseManager();
  late List<UserModel> classmates = [];
  late List recommendations;
  late int numLessons;
  Image img = Image.asset('assets/images/c2.jpg');
  String videoUrl = '';
  final ScrollController _controller =
  ScrollController(initialScrollOffset: 60.w);

  @override
  void initState() {
    _courseNotifier = Provider.of<CourseNotifier>(context, listen: false);
    numLessons = _courseNotifier.currentCourse.totalLessons;
    _homePageNotifier = Provider.of<HomePageNotifier>(context, listen: false);
    _userNotifier = Provider.of<UserNotifier>(context, listen: false);
    videoUrl = _courseNotifier.currentCourse.media[0];
    getNumLessons();
    getClassmates();
    recommendations = getRecommendation(
        _courseNotifier.courseList, _courseNotifier.currentCourse.prereqs);
    super.initState();
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

  Widget _conditionalBottomButton() {
    if (_userNotifier
        .getCourseIds()
        .contains(_courseNotifier.currentCourse.courseId)) {
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
          // _db.updateUserCourses(_userNotifier, _courseNotifier);
          // _homePageNotifier.isStateChanged = true;
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Platform.isAndroid == true? AlertDialog(title: Text("Checks and Limitations"),
                content: SizedBox(
                  height: 200,
                  child: Column(
                    children: const [
                      Text("1. ensure all prereq requirements are met"),
                      Text("2. ensure student cannot allowable limit"),
                    ],
                  ),
                ),)
                  : CupertinoAlertDialog(title: const Text("Checks and Limitations"),
                content: SizedBox(
                  height: 200,
                  child: Column(
                    children: const [
                      Text("1. ensure all prereq requirements are met"),
                      Text("2. ensure student cannot allowable limit"),
                    ],
                  ),
                ),);
            });

        },
        buttonText: 'Enroll',
      );
    }
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

  Widget _courseInfo() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //COURSE NAME
          SizedBox(
            width: 400,
            child: Padding(
              padding: const EdgeInsets.only(left: 25.0, top: 15),
              child: Animate(
                child: Text(
                  _courseNotifier.currentCourse.courseName,
                  style: const TextStyle(
                      fontSize: 38.00,
                      fontFamily: 'Roboto',
                      color: Color(0xff204548),
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
              ).fadeIn(duration: 1.seconds),
            ),
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
                      bgColour: Color(0xffffeeca)),
                  const SizedBox(
                    width: 8,
                  ),
                  InfoPill(
                      icon: 'assets/icons/lesson.png',
                      text: '$numLessons Lessons',
                      bgColour: Color(0xffd5f1d3)),
                  const SizedBox(
                    width: 10,
                  ),
                  FloatingActionButton(
                    backgroundColor: const Color(0xfff4e1fe),
                    foregroundColor: kTeal,
                    elevation: 0,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onPressed: () =>
                        Share.share(
                            "Check out the ${_courseNotifier.currentCourse
                                .courseName} course in the Study Sprint app."),
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
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Container(
                height: 100.h,
                width: double.infinity,
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: kGreyBackground,
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: classmates.isNotEmpty ? ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: classmates.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: Column(
                          children: [
                            CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.white,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(75.0),
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
                            Expanded(
                              child: Padding(
                                padding:
                                const EdgeInsets.symmetric(vertical: 2.0),
                                child: Text(
                                  classmates[index].displayName!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    }):const Center(child: Text('No one has enrolled on this course yet'),)
              )),
          recommendations.isNotEmpty
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25.0, bottom: 10, top: 10),
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
            Text(text, style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
