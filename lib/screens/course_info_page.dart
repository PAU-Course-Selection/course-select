import 'package:cached_network_image/cached_network_image.dart';
import 'package:course_select/controllers/course_notifier.dart';
import 'package:course_select/constants/constants.dart';
import 'package:course_select/shared_widgets/classmates.dart';
import 'package:course_select/shared_widgets/course_info_and_sharing.dart';
import 'package:course_select/shared_widgets/video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class CourseInfoPage extends StatefulWidget {
  const CourseInfoPage({
    Key? key,
  }) : super(key: key);

  @override
  State<CourseInfoPage> createState() => _CourseInfoPageState();
}

class _CourseInfoPageState extends State<CourseInfoPage> {
  late CourseNotifier _courseNotifier;
  Image img = Image.asset('assets/images/c2.jpg');
  String videoUrl = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_courseNotifier.currentCourse.courseName),
        backgroundColor: kPrimaryColour,
      ),
      body: _courseInfo(),
    );
  }

  @override
  void initState() {
    _courseNotifier = Provider.of<CourseNotifier>(context, listen: false);
    //print(_courseNotifier.currentCourse.media[0]);
    videoUrl = _courseNotifier.currentCourse.media[0];
    //print(videoUrl);
    super.initState();
  }

  Widget _courseInfo() {
    Column infoPage = Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        //COURSE NAME
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            _courseNotifier.currentCourse.courseName,
            style: const TextStyle(fontSize: 24.00, fontFamily: "Roboto"),
            textAlign: TextAlign.left,
          ),
        ),

        //MEDIA LIST
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                //borderRadius: BorderRadius.circular(16.0),
                ),
            height: 300.h,
            width: double.infinity,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _courseNotifier.currentCourse.media.length,
              itemBuilder: (context, index) {
                return _photoVideoView(index);
              },
            ),
          ),
        ),

        //ROW WITH SHARE BUTTON
        MiniCourseInfoAndShare(),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //   children: [
        //     Padding(
        //       padding: const EdgeInsets.fromLTRB(
        //         4.0,
        //         4.0,
        //         4.0,
        //         4.0,
        //       ),
        //       child: Container(
        //         padding: const EdgeInsets.all(16.0),
        //         decoration: BoxDecoration(
        //             boxShadow: kSomeShadow,
        //             color: kLightGreen,
        //             borderRadius:
        //                 const BorderRadius.all(Radius.circular(32.0))),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceAround,
        //           children: const [
        //             Padding(
        //               padding: EdgeInsets.fromLTRB(0.0,0.0,8.0,4.0),
        //               child: Icon(Icons.book),
        //             ),
        //             Text("22 Lessons"),
        //           ],
        //         ),
        //       ),
        //     ),
        //     Container(
        //       padding: const EdgeInsets.all(16.0),
        //       decoration: BoxDecoration(
        //         boxShadow: kSomeShadow,
        //         color: kLightGreen,
        //         borderRadius: const BorderRadius.all(
        //           Radius.circular(32.0),
        //         ),
        //       ),
        //       child: Row(
        //         children: [
        //           Padding(
        //             padding: EdgeInsets.fromLTRB(0.0,0.0,8.0,4.0),
        //             child: const Icon(Icons.timelapse),
        //           ),
        //           Text(_hoursPerWeek()),
        //         ],
        //       ),
        //     ),
        //     ElevatedButton(
        //       onPressed: () => Share.share(
        //           "Check out the ${_courseNotifier.currentCourse.courseName} course in the Study Sprint app."),
        //       child: const Icon(Icons.share),
        //       style: ButtonStyle(
        //           padding: const MaterialStatePropertyAll<EdgeInsetsGeometry>(
        //               EdgeInsets.all(16.0)),
        //           shape: const MaterialStatePropertyAll<OutlinedBorder>(
        //               CircleBorder()),
        //           backgroundColor:
        //                MaterialStatePropertyAll<Color>(kPrimaryColour),
        //           foregroundColor:
        //               const MaterialStatePropertyAll<Color>(Colors.black),
        //           elevation: MaterialStateProperty.all(8.0)),
        //     ),
        //   ],
        // ),
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
        const Text(
          "Classmates",
          style: TextStyle(
              fontFamily: "Roboto",
              fontSize: 16.0,
              fontWeight: FontWeight.bold),
        ),
        //Classmates Box
        Classmates(),
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
        {
          return _courseVideo();
        }

      case "photo":
        {
          return _courseImage(index);
        }
      default:
        {
          return Container();
        }
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
