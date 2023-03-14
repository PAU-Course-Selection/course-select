///Course model class with attributes which define what a course is
class Course{
  String subjectArea = '';
  String level = '';
  String courseId = '';
  String courseName = '';
  int hoursPerWeek = 0;
  int duration = 0;
  List prereqs = [];
  bool isSaved=false;
  String courseImage = '';


  Course(this.subjectArea, this.level, this.courseId, this.courseName,
      this.hoursPerWeek, this.duration, this.prereqs,this.isSaved, this.courseImage,);

  ///Receives a map which matches class attributes
  ///This is useful for storing, persisting and fetching data from firestore
  Course.fromMap(Map<String, dynamic> data) {
    subjectArea = data['subjectArea'];
    level = data['level'];
    courseId = data['courseId'];
    courseName = data['courseName'];
    hoursPerWeek = data['hoursPerWeek'];
    duration = data['duration'];
    prereqs = data['prereqs'];
  }
}