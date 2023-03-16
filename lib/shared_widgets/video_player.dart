import 'dart:async';

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
  late Future<void> _initializeVideoPlayerFuture;
  late FlickManager flickManager;

  // bool _onTouch = false;

  // late Timer _timer;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoPath);
    _initializeVideoPlayerFuture = _controller.initialize();
    flickManager = FlickManager(videoPlayerController: _controller);

    // _timer = Timer.periodic(
    //     const Duration(milliseconds: 100), (_) {
    //   setState(() {
    //     _onTouch = _onTouch;
    //   });
    // });
    _controller.setLooping(true);
    _controller.initialize().then((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    flickManager.dispose();
    // _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
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
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
//   return _controller.value.isInitialized
//       ? Stack(
//           children: <Widget>[
//             FutureBuilder(
//               future: _initializeVideoPlayerFuture,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.done) {
//                   // If the VideoPlayerController has finished initialization, use
//                   // the data it provides to limit the aspect ratio of the video.
//                   return AspectRatio(
//                     aspectRatio: _controller.value.aspectRatio,
//                     // Use the VideoPlayer widget to display the video.
//                     child: VideoPlayer(_controller),
//                   );
//                 } else {
//                   // If the VideoPlayerController is still initializing, show a
//                   // loading spinner.
//                   return const Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 }
//               },
//             ),
//
//             // Add a play or pause button overlay
//             Visibility(
//               visible: true,
//               child: Container(
//                 color: Colors.grey.withOpacity(0.5),
//                 alignment: Alignment.center,
//                 child: ElevatedButton(
//                   style: const ButtonStyle(
//                       shape: MaterialStatePropertyAll<CircleBorder>(
//                           CircleBorder(
//                               side: BorderSide(color: Colors.white)))),
//                   child: Icon(
//                     _controller.value.isPlaying
//                         ? Icons.pause
//                         : Icons.play_arrow,
//                     color: Colors.white,
//                   ),
//                   onPressed: () {
//                //     _timer.cancel();
//
//                     // pause while video is playing, play while video is pausing
//                     setState(() {
//                       _controller.value.isPlaying
//                           ? _controller.pause()
//                           : _controller.play();
//                     });
//
//                     // Auto dismiss overlay after 1 second
//                     // _timer = Timer.periodic(
//                     //     const Duration(milliseconds: 1000), (_) {
//                     //   setState(() {
//                     //     _onTouch = false;
//                     //   });
//                     // });
//                   },
//                 ),
//               ),
//             )
//           ],
//         )
//       : Center(child: CircularProgressIndicator());
// }
}
