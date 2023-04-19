import 'package:cloud_firestore/cloud_firestore.dart';

///Course model class with attributes which define what a course is
class Lesson{
  String courseId = '';
  String lessonName = '';
  String link = '';
  Timestamp? startTime = Timestamp.now();
  Timestamp? endTime = Timestamp.now();


  Lesson(this.lessonName, this.link, this.startTime, this.endTime, this.courseId);

  ///Receives a map which matches class attributes
  ///This is useful for storing, persisting and fetching data from firestore
  Lesson.fromMap(Map<String, dynamic> data) {
    courseId = data['courseId'];
    lessonName = data['lessonName'];
    link = data['link'];
    startTime = data['startTime'];
    endTime = data['endTime'];
  }
}