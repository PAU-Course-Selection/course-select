import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/constants.dart';

class SavedCourseCard extends StatefulWidget {
  final String courseName;
  final String courseImage;
  final String subjectArea;
  final int duration;
  final String skillLevel;
  final Function onDeleteTapped;
  final bool isDeleted;
  const SavedCourseCard({Key? key, required this.courseName, required this.courseImage, required this.subjectArea, required this.duration, required this.skillLevel, required this.onDeleteTapped, required this.isDeleted}) : super(key: key);

  @override
  State<SavedCourseCard> createState() => _SavedCourseCardState();
}

class _SavedCourseCardState extends State<SavedCourseCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.only(bottom: 10.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color:
          kLightBackground.withOpacity(0.2),
        ),
        child: Stack(
          children: [
            Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(
                        10)),
                height: 100,
                width: 100,
                child: CachedNetworkImage(
                  imageUrl: widget.courseImage,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.circular(10),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )),
            Positioned(
              left: 80.w,
              child: Container(
                padding:  EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.courseName
                          .length >
                          20
                          ? widget
                          .courseName
                          .substring(
                          0, 20) +
                          '...'
                          : widget
                          .courseName,
                      style: const TextStyle(
                        fontWeight:
                        FontWeight.bold,
                        fontSize: 18,
                      ),
                      overflow:
                      TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      widget
                          .subjectArea,
                      style: const TextStyle(
                          fontSize: 16),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.only(
                          top: 5.0),
                      child: Text(
                        '${widget.duration} weeks',
                        style: const TextStyle(
                            color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
                right: 10,
                child: GestureDetector(
                  onTap: () => widget.onDeleteTapped.call(),
                  child: Container(
                    padding:
                    const EdgeInsets.all(15),
                    child: widget.isDeleted
                        ? Animate(
                      child: Icon(
                          Icons
                              .delete_forever,
                          color:
                          kPrimaryColour),
                    )
                        .animate()
                        .shake(
                        hz: 1,
                        curve: Curves
                            .easeInOutCubic,
                        duration: 500.ms)
                        .shimmer(
                        delay: 10.ms,
                        duration: 1000.ms)
                        .scaleXY(
                        end: 1.2,
                        duration: 100.ms)
                        .then(delay: 1.ms)
                        .scaleXY(
                        end: 1 / 1.2,
                        curve: Curves
                            .bounceInOut)
                        : Icon(
                      Icons
                          .delete_outline,
                      color: Colors.orange
                          .withOpacity(0.5),
                    ),
                  ),
                )),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                    color: kPrimaryColour
                        .withOpacity(0.2),
                    borderRadius:
                    const BorderRadius.only(
                        topLeft:
                        Radius.circular(
                            10),
                        bottomRight:
                        Radius.circular(
                            10))),
                height: 30,
                width: 100.w,
                child: Center(
                    child: Text(widget
                        .skillLevel)),
              ),
            )
          ],
        ),
        width: double.infinity,
      ),
    );
  }
}
