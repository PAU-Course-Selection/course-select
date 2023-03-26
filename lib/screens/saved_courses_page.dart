import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_select/controllers/home_page_notifier.dart';
import 'package:course_select/screens/search_sheet.dart';
import 'package:course_select/shared_widgets/mini_course_card.dart';
import 'package:course_select/shared_widgets/saved_course_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../shared_widgets/gradient_button.dart';
import '../utils/auth.dart';

class SavedCourses extends StatefulWidget {
  const SavedCourses({Key? key}) : super(key: key);

  @override
  State<SavedCourses> createState() => _SavedCoursesState();
}

class _SavedCoursesState extends State<SavedCourses> {
  final User? user = Auth().currentUser;
  late String myDocId;
  late Future<String> futureData;
  bool deleteTapped = false;

  late final DocumentReference<Map<String, dynamic>>? userRef;
  late Query<Map<String, dynamic>>? favoritesQuery;

  @override
  void initState() {
    super.initState();
    futureData = getDocId();
  }

  Future<String> getDocId() async {
    var myUser = await FirebaseFirestore.instance
        .collection('Users')
        .where('uid', isEqualTo: user?.uid)
        .get();
    if (myUser.docs.isNotEmpty) {
      var docId = myUser.docs.first.id;
      return docId;
    }
    throw Exception('User document not found');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Shortlist',
          style: kHeadlineMedium,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: FutureBuilder<String>(
        future: futureData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userRef = FirebaseFirestore.instance
                .collection('Users')
                .doc(snapshot.data!);
            final favoritesQuery = userRef
                .collection('Favourites')
                .orderBy('savedAt', descending: true);

            return StreamBuilder<QuerySnapshot>(
                stream: favoritesQuery.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (!snapshot.hasData) {
                    print('loading');
                    return const CircularProgressIndicator();
                  }

                  final documents = snapshot.data!.docs;


                  if (documents.isEmpty && snapshot.connectionState == ConnectionState.done) {
                    print('empty and done loading');
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(
                            25.0,
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: kLightBackground.withOpacity(0.2),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ImageIcon(
                                  const AssetImage('assets/icons/bookmark.png'),
                                  color: kSaraAccent,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Create a shortlist',
                                  style: kHeadlineMedium.copyWith(fontSize: 16),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                SizedBox(
                                    width: 200.w,
                                    child: const Text(
                                      'Make it easier with less options to choose from',
                                      textAlign: TextAlign.center,
                                    ))
                              ],
                            ),
                            width: double.infinity,
                          ),
                        ),
                        Flexible(
                            child: Padding(
                              padding: const EdgeInsets.all(25.0),
                              child: GradientButton(
                                buttonText: 'Add Courses',
                                onPressed: () {
                                  showCupertinoModalBottomSheet(
                                    duration: const Duration(milliseconds: 100),
                                    topRadius: const Radius.circular(20),
                                    barrierColor: Colors.black54,
                                    elevation: 8,
                                    context: context,
                                    builder: (context) => const Material(
                                        child: SearchSheet(
                                          filter: 'all',
                                        )),
                                  );
                                },
                              ),
                            ))
                      ],
                    );
                  }
                  return ListView.builder(
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        final courseName = documents[index].get('courseName');
                        final courseImage = documents[index].get('courseImage');
                        final subjectArea = documents[index].get('subjectArea');
                        final duration = documents[index].get('duration');
                        final skillLevel = documents[index].get('skillLevel');
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: SavedCourseCard(
                              courseName: courseName,
                              courseImage: courseImage,
                              subjectArea: subjectArea,
                              duration: duration,
                              skillLevel: skillLevel,
                              onDeleteTapped: (){
                                setState(() {
                                  deleteTapped = !deleteTapped;
                                });
                              },
                              isDeleted: deleteTapped),
                        );
                      });
                }
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            ///Shimmer
            return  Container();
          }
        },
      ),
    );
  }

}
