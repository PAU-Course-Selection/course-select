import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/course_data_model.dart';
import '../constants/constants.dart';

class MiniCourseCard extends StatefulWidget {
  const MiniCourseCard({
    Key? key,
    required this.displayList, required this.index, required this.onBookmarkTapped, required this.onCardPressed,
  }) : super(key: key);

  final List<Course> displayList;
  final int index;
  final Function onCardPressed;
  final Function onBookmarkTapped;

  @override
  State<MiniCourseCard> createState() => _MiniCourseCardState();
}

class _MiniCourseCardState extends State<MiniCourseCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.only(bottom: 10.0),
      child: GestureDetector(
        onTap: () => widget.onCardPressed.call(),
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
                    imageUrl: widget.displayList[widget.index]
                        .media[1],
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
                        widget.displayList[widget.index]
                            .courseName
                            .length >
                            20
                            ? widget.displayList[widget.index]
                            .courseName
                            .substring(
                            0, 20) +
                            '...'
                            : widget.displayList[widget.index]
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
                        widget.displayList[widget.index]
                            .subjectArea,
                        style: const TextStyle(
                            fontSize: 16),
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.only(
                            top: 5.0),
                        child: Text(
                          '${widget.displayList[widget.index].duration} weeks',
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
                    onTap: () => widget.onBookmarkTapped.call(),
                    child: Container(
                      padding:
                      const EdgeInsets.all(15),
                      child: widget.displayList[widget.index]
                          .isSaved
                          ? Animate(
                        child: Icon(
                            Icons
                                .bookmark_added,
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
                            .bookmark_border_rounded,
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
                      child: Text(widget.displayList[widget.index]
                          .level)),
                ),
              )
            ],
          ),
          width: double.infinity,
        ),
      ),
    );
  }
}