import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_select/shared_widgets/course_list_shimmer.dart';
import 'package:course_select/shared_widgets/empty_saved_page.dart';
import 'package:course_select/shared_widgets/mini_course_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  late List<Course> savedList = [];

  void stateChanged(){
    setState(() {

    });
  }


  late final DocumentReference<Map<String, dynamic>>? userRef;
  late Query<Map<String, dynamic>>? favoritesQuery;

  @override
  void initState() {
    super.initState();
    savedCoursesNotifier = Provider.of<SavedCoursesNotifier>(context, listen: false);
    getDocId().then((value){
      myDocId = value;
      setState(() {
        futureData = getModels();
        futureString = getDocId();
        savedList = savedCoursesNotifier.savedCourses;
      });
    }
    ).whenComplete(()  {

    });
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
  Future getModels() {
    //db.getUsers(userNotifier);
    return db.getSavedCourses(savedCoursesNotifier, myDocId);
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
      body: FutureBuilder(
        future: futureData,
        builder: (context, snapshot) {
          if(savedList.isEmpty){
            savedList = savedCoursesNotifier.savedCourses;
          }
          if(savedList.isEmpty && snapshot.connectionState == ConnectionState.waiting){
            return Column(
              children: const [
                CourseListShimmer(),
                CourseListShimmer(),
                CourseListShimmer(),
              ],
            );
          }
          if(savedList.isEmpty && snapshot.connectionState == ConnectionState.done){
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
                    height: MediaQuery.of(context).size.height * 0.80,
                    child: const Empty()),
              )
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SavedCourseTile(savedList: savedList);
          }
          else if(snapshot.connectionState == ConnectionState.done){
            return SavedCourseTile(savedList: savedList);
          }
          else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
            ///Shimmer
            return  const Center(child: Text('Shimmer'),);

        },
      ),
    );
  }
}

class SavedCourseTile extends StatelessWidget {
  const SavedCourseTile({
    Key? key,
    required this.savedList,
  }) : super(key: key);

  final List<Course> savedList;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: savedList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Slidable(
                  key: const ValueKey(0),
                  // The start action pane is the one at the left or the top side.
                  endActionPane: ActionPane(
                    // A motion is a widget used to control how the pane animates.
                    motion: const ScrollMotion(),

                    // A pane can dismiss the Slidable.
                    dismissible: DismissiblePane(onDismissed: () {}),

                    // All actions are defined in the children parameter.
                    children:  [
                      // A SlidableAction can have an icon and/or a label.
                      SlidableAction(
                        onPressed: (context){},
                        backgroundColor: Color(0xFF21B7CA),
                        foregroundColor: Colors.white,
                        icon: Icons.share,
                        label: 'Share',
                      ),

                      SlidableAction(
                        onPressed: (context){},
                        backgroundColor: Color(0xFFFE4A49),
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                    ],
                  ),
                  child: SavedCourseCard(
                    displayList: savedList,
                    index: index,
                  )),
            );
          }),
    );
  }

}
