import 'package:cached_network_image/cached_network_image.dart';
import 'package:course_select/controllers/course_notifier.dart';
import 'package:course_select/constants/constants.dart';
import 'package:course_select/controllers/home_page_notifier.dart';
import 'package:course_select/models/user_data_model.dart';
import 'package:course_select/shared_widgets/classmates.dart';
import 'package:course_select/shared_widgets/course_info_and_sharing.dart';
import 'package:course_select/shared_widgets/gradient_button.dart';
import 'package:course_select/shared_widgets/video_player.dart';
import 'package:course_select/utils/firebase_data_management.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

import '../controllers/user_notifier.dart';

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
  Image img = Image.asset('assets/images/c2.jpg');
  String videoUrl = '';
  final ScrollController _controller =
      ScrollController(initialScrollOffset: 60.w);

  @override
  void initState() {
    _courseNotifier = Provider.of<CourseNotifier>(context, listen: false);
    _homePageNotifier = Provider.of<HomePageNotifier>(context, listen: false);
    _userNotifier = Provider.of<UserNotifier>(context, listen: false);
    videoUrl = _courseNotifier.currentCourse.media[0];
    getClassmates();
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

  Widget _conditionalButtomButton() {
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
          _db.updateUserCourses(_userNotifier, _courseNotifier);
          _homePageNotifier.isStateChanged = true;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              elevation: 1,
              behavior: SnackBarBehavior.fixed,
              backgroundColor: kKindaGreen,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              content: const Center(
                  child: Text(
                "Successfully Enrolled",
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
        buttonText: 'Enroll',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    for(var user in classmates){
      print(user.email);
    }
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
        child: _conditionalButtomButton(),
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
          const MiniCourseInfoAndShare(),
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
                padding: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  color: kGreyBackground,
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                    itemCount: classmates.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: CircleAvatar(
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
                      );
                    }),
              ))
        ],
      ),
    );
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
