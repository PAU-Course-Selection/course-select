import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class CourseListShimmer extends StatelessWidget {
  const CourseListShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color(0xfff3f3f3),
        ),
        child: Stack(
          children: [
            Shimmer.fromColors(
        baseColor: const Color(0xffebebeb),
          highlightColor: const Color(0xfff9f9f9),
              child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.circular(
                          10)),
                  height: 100,
                  width: 100,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                        borderRadius: BorderRadius.circular(15)),
                  )),
            ),
            Positioned(
              left: 80.w,
              child: Shimmer.fromColors(
                baseColor: const Color(0xffebebeb),
                highlightColor: const Color(0xfff9f9f9),
                child: Container(
                  padding:  EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children:  [
                      Shimmer.fromColors(
                        baseColor: const Color(0xffebebeb),
                        highlightColor: const Color(0xfff9f9f9),
                        child: Container(
                          color: Colors.grey,
                          width: 200.w,
                          height: 15,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Shimmer.fromColors(
                        baseColor: const Color(0xffebebeb),
                        highlightColor: const Color(0xfff9f9f9),
                        child: Container(
                          color: Colors.grey,
                          width: 100,
                          height: 15,
                        ),
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.only(
                            top: 5.0),
                        child: Shimmer.fromColors(
                          baseColor: const Color(0xffebebeb),
                          highlightColor: const Color(0xfff9f9f9),
                          child: Container(
                            color: Colors.grey,
                            width: 80,
                            height: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
             Positioned(
                right: 10,
                child: Shimmer.fromColors(
                  baseColor: const Color(0xffebebeb),
                  highlightColor: const Color(0xfff9f9f9),
                  child: const Icon(
                      Icons
                          .bookmark_added,
                      color:
                      Colors.grey),
                )),
            Positioned(
              right: 0,
              bottom: 0,
              child: Shimmer.fromColors(
                baseColor: const Color(0xffebebeb),
                highlightColor: const Color(0xfff9f9f9),
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.grey,
                      borderRadius:
                      BorderRadius.only(
                          topLeft:
                          Radius.circular(
                              10),
                          bottomRight:
                          Radius.circular(
                              10))),
                  height: 30,
                  width: 100.w,
                  child: const Center(
                      child: SizedBox(
                        width: 15,
                        height: 10,
                      ),),
                ),
              ),
            )
          ],
        ),
        width: double.infinity,
      ),
    );
  }
}
