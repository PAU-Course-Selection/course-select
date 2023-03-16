import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import 'constants.dart';

class CourseCard extends StatefulWidget {
  final String courseTitle;
  final String courseImage;
  final String subjectArea;
  final int hoursPerWeek;

  const CourseCard({Key? key, required this.courseTitle,
    required this.courseImage, required this.subjectArea,
    required this.hoursPerWeek}) : super(key: key);

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: CachedNetworkImage(
        imageUrl: widget.courseImage,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
              color: const Color(0xffa7fcd1),
              image:  DecorationImage(image: imageProvider, fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                    color: Color.fromRGBO(143, 148, 251, .1),
                    blurRadius: 10.0,
                    offset: Offset(0, 1)
                ),
                BoxShadow(
                    color: Color.fromRGBO(143, 148, 251, .1),
                    blurRadius: 10.0,
                    offset: Offset(0, 1)
                )
              ]
          ),
          width: screenWidth * 0.70,
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                child: Container(
                  decoration: const BoxDecoration(
                      color: Color(0xffE1F0EC),
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))),
                  height: 110,
                  width: screenWidth * 0.70,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.courseTitle, style: kHeadlineMedium.copyWith(fontSize: 18),
                          maxLines: 1, overflow: TextOverflow.ellipsis,),
                        const SizedBox(height: 5,),
                        Text(widget.subjectArea, style: kHeadlineMedium.copyWith(fontSize: 16, fontWeight: FontWeight.normal),
                          maxLines: 2, overflow: TextOverflow.ellipsis,),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            children:  [
                              ImageIcon(const AssetImage('assets/icons/calendar.png'), color: kPrimaryColour,),
                              const SizedBox(
                                width: 5,
                              ),
                              Text('${widget.hoursPerWeek} weeks'),
                              const SizedBox(
                                width: 25,
                              ),
                              ImageIcon(const AssetImage('assets/icons/book3.png'), color: kPrimaryColour,),
                              const SizedBox(
                                width: 5,
                              ),
                              const Text('20 lessons')
                            ],),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
