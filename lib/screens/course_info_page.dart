import 'package:cached_network_image/cached_network_image.dart';
import 'package:course_select/controllers/course_notifier.dart';
import 'package:course_select/constants/constants.dart';
import 'package:course_select/controllers/home_page_notifier.dart';
import 'package:course_select/shared_widgets/classmates.dart';
import 'package:course_select/shared_widgets/course_info_and_sharing.dart';
import 'package:course_select/shared_widgets/video_player.dart';
import 'package:course_select/utils/firebase_data_management.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

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
  Image img = Image.asset('assets/images/c2.jpg');
  String videoUrl = '';
  final ScrollController _controller = ScrollController(initialScrollOffset: 60.w);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Course Info', style: kHeadlineMedium,),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: _courseInfo(),
    );
  }

  @override
  void initState() {
    _courseNotifier = Provider.of<CourseNotifier>(context, listen: false);
    _homePageNotifier = Provider.of<HomePageNotifier>(context, listen: false);
    _userNotifier = Provider.of<UserNotifier>(context, listen: false);
    videoUrl = _courseNotifier.currentCourse.media[0];
    super.initState();
  }

  Widget _courseInfo() {

    Column infoPage = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //COURSE NAME
        SizedBox(
          width: 400,
          child: Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 15),
            child: Text(
              _courseNotifier.currentCourse.courseName,
              style:  TextStyle(fontSize: 38.00, fontFamily: 'Roboto', color: Color(0xff204548),
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
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
          padding: const EdgeInsets.fromLTRB(
            16.0,
            4.0,
            16.0,
            4.0,
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
                color: const Color(0xffE1F0EC),
                borderRadius: BorderRadius.circular(16.0)),
            child: const Text(
                "Course Description Course Description Course Description Course Description Course Description Course Description "),
          ),
        ),
        //Classmates Heading
         ElevatedButton(
          onPressed: (){
            _db.updateUserCourses(_userNotifier, _courseNotifier);
            _homePageNotifier.isStateChanged = true;
          ScaffoldMessenger.of(context)
              .showSnackBar(
          SnackBar(
            elevation: 1,
            behavior:
            SnackBarBehavior.fixed,
            backgroundColor: kKindaGreen,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5)),
            content:
            const Center(
                child: Text(
                "Successfully Enrolled",
                style: TextStyle(
                    color: Colors.black45,
                    fontSize: 15.0,
                    fontFamily: "Robots",
                    fontWeight: FontWeight.bold),
          )),
          duration:
          const Duration(seconds: 1),
          ),
          );
          },
           child: const Text(
             "Enroll",
             style: TextStyle(
                 fontSize: 20.0,
                 fontWeight: FontWeight.bold
             ),
           ),
        ),
        const Text(
          "Classmates",
          style: TextStyle(
              fontFamily: "Roboto",
              fontSize: 16.0,
              fontWeight: FontWeight.bold),
        ),
        //Classmates Box
        const Classmates(),
      ],
    );




    return infoPage;
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
          borderRadius: BorderRadius.circular(16.0),
          elevation: 10,
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
            borderRadius: BorderRadius.circular(16.0),
            clipBehavior: Clip.hardEdge,
            elevation: 5,
            child: CourseVideoPlayer(videoPath: videoUrl),
          ),
        ));
  }
}
