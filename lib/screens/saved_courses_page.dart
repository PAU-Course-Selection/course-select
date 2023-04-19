import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_select/controllers/course_notifier.dart';
import 'package:course_select/shared_widgets/course_list_shimmer.dart';
import 'package:course_select/shared_widgets/empty_saved_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../models/course_data_model.dart';
import '../shared_widgets/saved_course_card.dart';
import '../utils/auth.dart';
import '../utils/firebase_data_management.dart';
import '../models/saved_course_data_model.dart';

class SavedCourses extends StatefulWidget {
  const SavedCourses({Key? key}) : super(key: key);

  @override
  State<SavedCourses> createState() => _SavedCoursesState();
}

class _SavedCoursesState extends State<SavedCourses> {
  final User? user = Auth().currentUser;
  DatabaseManager db = DatabaseManager();
  late String myDocId;
  late Future<String> futureString;
  bool deleteTapped = false;
  late Future futureData = Future.value([]);
  late SavedCoursesNotifier savedCoursesNotifier;
  late CourseNotifier courseNotifier;
  late List<Course> savedList = [];

  late final DocumentReference<Map<String, dynamic>>? userRef;
  late Query<Map<String, dynamic>>? favoritesQuery;


  /// Initialise controllers and get data from the database for user's saved courses
  @override
  void initState() {
    super.initState();
    savedCoursesNotifier =
        Provider.of<SavedCoursesNotifier>(context, listen: false);

    courseNotifier = Provider.of<CourseNotifier>(context, listen: false);
    getDocId().then((value) {
      myDocId = value;
      setState(() {
        futureData = getModels();
        futureString = getDocId();
        savedList = savedCoursesNotifier.savedCourses.toList();
      });
    }).whenComplete(() {});
  }

  /// Get the users document ID to retrieve their saved courses from the database
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

  /// Get the current user's saved courses
  Future getModels() {
    //db.getUsers(userNotifier);
    return db.getSavedCourses(savedCoursesNotifier, myDocId);
  }


  /// Remove a saved course from the database
   Future<dynamic> _deleteDocument() async {
    print('called');
    await db.test();
    if(mounted){
      setState(() {
        futureData = getModels();
      });
    }
  }

  /// Ensures state is mounted
  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }


  /// Builds the saved course list or else displays a button prompting the user to save courses from the main list
  @override
  Widget build(BuildContext context) {
    print('rebuilt');
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
      body: FutureBuilder(
        future: futureData,
        builder: (context, snapshot) {
          if (savedList.isEmpty) {
            savedList = savedCoursesNotifier.savedCourses;
          }
          if (savedList.isEmpty &&
              snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              children: const [
                CourseListShimmer(),
                CourseListShimmer(),
                CourseListShimmer(),
              ],
            );
          }
          if (savedList.isEmpty &&
              snapshot.connectionState == ConnectionState.done) {
            return RefreshIndicator(
                color: kPrimaryColour,
                onRefresh: () {
                  HapticFeedback.heavyImpact();
                  setState(() {
                    futureData = getModels();
                  });
                  return futureData;
                },
                child: SingleChildScrollView(
                  child: SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.80.w,
                      child:   EmptyFavouritesPage(onAdd: _deleteDocument,),
                )));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SavedCourseTile(
              savedList: savedList,
              savedCoursesNotifier: savedCoursesNotifier,
              courseNotifier: courseNotifier,
              db: db, onDelete: _deleteDocument,
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            return SavedCourseTile(savedList: savedList, savedCoursesNotifier: savedCoursesNotifier,
              courseNotifier: courseNotifier, db: db, onDelete: _deleteDocument,);
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          ///Shimmer
          return const Center(
            child: Text('Shimmer'),
          );
        },
      ),
    );
  }
}

/// Encapsulated the tiles that make up saved course list items
/// Saved courses can be shared or deleted
class SavedCourseTile extends StatefulWidget {
  final SavedCoursesNotifier savedCoursesNotifier;
  final CourseNotifier courseNotifier;
  final List<Course> savedList;
  final DatabaseManager db;
  final Function onDelete;

  const SavedCourseTile(
      {Key? key,
      required this.savedList,
      required this.savedCoursesNotifier,
      required this.courseNotifier,
      required this.db, required this.onDelete})
      : super(key: key);

  @override
  State<SavedCourseTile> createState() => _SavedCourseTileState();
}

class _SavedCourseTileState extends State<SavedCourseTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: widget.savedList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Slidable(
                  key: Key(widget.savedList[index].courseId),
                  // The start action pane is the one at the left or the top side.
                  endActionPane: ActionPane(
                    // A motion is a widget used to control how the pane animates.
                    motion: const ScrollMotion(),

                    // A pane can dismiss the Slidable.
                    dismissible: DismissiblePane(
                        onDismissed: () {
                          widget.onDelete.call();
                      _handleRemoveSavedCourse(index);
                    } ),

                    // All actions are defined in the children parameter.
                    children: [
                      // A SlidableAction can have an icon and/or a label.
                      SlidableAction(
                        autoClose: true,
                        onPressed: (context) {},
                        backgroundColor: const Color(0xFF21B7CA),
                        foregroundColor: Colors.white,
                        icon: Icons.share,
                        label: 'Share',
                      ),

                      SlidableAction(
                        autoClose: true,
                        onPressed: (context) => _handleRemoveSavedCourse(index),
                        backgroundColor: const Color(0xFFFE4A49),
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                    ],
                  ),
                  child: SavedCourseCard(
                    displayList: widget.savedList,
                    index: index,
                  )),
            );
          }),
    );
  }

  /// Deals with the removal of a saved course when the user slides the course off the list or taps delete
   _handleRemoveSavedCourse(int index) {
    widget.courseNotifier.currentCourse = widget.savedList[index];
    widget.db.removeSavedCourseSubCollection(
      savedCourses: widget.savedCoursesNotifier,
      courseNotifier: widget.courseNotifier,
      courseName: widget.savedList[index].courseName,
    );
    widget.savedList.removeAt(index);
  }
}
