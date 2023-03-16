import 'package:cached_network_image/cached_network_image.dart';
import 'package:course_select/controllers/course_notifier.dart';
import 'package:course_select/shared_widgets/video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class CourseInfo extends StatefulWidget {
  final String courseTitle;
  final String courseImage;

  //final int courseLessons;
  final int weeks;
  final int weeklyHours;

  const CourseInfo({
    Key? key,
    required this.courseImage,
    required this.courseTitle,
    //  required this.courseLessons,
    required this.weeks,
    required this.weeklyHours,
  }) : super(key: key);

  @override
  State<CourseInfo> createState() => _CourseInfoState();
}

class _CourseInfoState extends State<CourseInfo> {
  late CourseNotifier _courseNotifier;
  Image img = Image.asset('assets/images/c2.jpg');
  String videoUrl = '';

  @override
  Widget build(BuildContext context) {
    return _courseInfo();
  }

  @override
  void initState() {
    _courseNotifier = Provider.of<CourseNotifier>(context, listen: false);
    print(_courseNotifier.currentCourse.media[0]);
    videoUrl = _courseNotifier.currentCourse.media[0];
    print(videoUrl);
    super.initState();
  }


  Widget _courseInfo() {
    Column infoPage = Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            widget.courseTitle,
            style: const TextStyle(
              fontSize: 24.00,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(16.0)),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                4.0,
                8.0,
                8.0,
                4.0,
              ),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: const BoxDecoration(
                    color: Color(0xffE1F0EC),
                    borderRadius: BorderRadius.all(Radius.circular(32.0))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Icon(Icons.book),
                    Text("22 Lessons"),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: Color(0xffE1F0EC),
                borderRadius: BorderRadius.all(
                  Radius.circular(32.0),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.timelapse),
                  Text(_hoursPerWeek()),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: _shareCourse(),
              child: const Icon(Icons.share),
              style: ButtonStyle(
                  padding: const MaterialStatePropertyAll<EdgeInsetsGeometry>(
                      EdgeInsets.all(16.0)),
                  shape: const MaterialStatePropertyAll<OutlinedBorder>(
                      CircleBorder()),
                  backgroundColor:
                      const MaterialStatePropertyAll<Color>(Color(0xffE1F0EC)),
                  elevation: MaterialStateProperty.all(8.0)),
            ),
          ],
        ),
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
        const Text(
          "Classmates",
          style: TextStyle(
              fontFamily: "Roboto",
              fontSize: 16.0,
              fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            16.0,
            8.0,
            16.0,
            4.0,
          ),
          child: Container(
            height: 100.h,
            width: double.infinity,
            padding: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: const Color(0xffE1F0EC),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  radius: 30,
                  child: ImageIcon(AssetImage("assets/images/female.png")),
                ),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  radius: 30,
                  child: ImageIcon(AssetImage("assets/images/male.png")),
                ),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  radius: 30,
                  child: ImageIcon(AssetImage("assets/images/female.png")),
                ),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  radius: 30,
                  child: ImageIcon(AssetImage("assets/images/male.png")),
                ),
              ],
            ),
          ),
        )
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
          elevation: 20,
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
          aspectRatio: 370/250,
          child: Material(
            elevation: 20,
            child: CourseVideoPlayer(videoPath: videoUrl)
          )),
    );
  }

  _shareCourse() {}

  String _hoursPerWeek() {
    String hpw = _courseNotifier.currentCourse.hoursPerWeek.toString();

    return "$hpw Weeks ";
  }
}
