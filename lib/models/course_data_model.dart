class Course {
  String subjectArea = '';
  String level = '';
  String courseId = '';
  String courseName = '';
  int hoursPerWeek = 0;
  int duration = 0;
  List prereqs = [];

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