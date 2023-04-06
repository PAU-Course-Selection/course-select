
import 'package:course_select/constants/constants.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CourseVideoPlayer extends StatefulWidget {
  final String videoPath;

  const CourseVideoPlayer({Key? key, required this.videoPath})
      : super(key: key);

  @override
  State<CourseVideoPlayer> createState() => _CourseVideoPlayerState();
}

class _CourseVideoPlayerState extends State<CourseVideoPlayer> {
  late VideoPlayerController _controller;
  late FlickManager flickManager;

  @override
  void initState() {
    _controller = VideoPlayerController.network(widget.videoPath)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });

    flickManager = FlickManager(
      videoPlayerController:
      VideoPlayerController.network(widget.videoPath),
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _controller.initialize(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && _controller.value.isInitialized) {
          // If the VideoPlayerController has finished initialization, use
          // the data it provides to limit the aspect ratio of the video.

          return AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            // Use the VideoPlayer widget to display the video.
            child: FlickVideoPlayer(flickManager: flickManager),
          );
        } else {
          // If the VideoPlayerController is still initializing, show a
          // loading spinner.
          return  Center(
            child: Container(
              decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/c2.jpg'), fit: BoxFit.cover)),
                child: Center(
                    child: CircularProgressIndicator(
                      color: kPrimaryColour,
                    ))),
          );
        }
      },
    );
  }
}
