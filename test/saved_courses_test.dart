import 'package:course_select/models/course_data_model.dart';
import 'package:course_select/models/saved_course_data_model.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  group('Testing App Provider', () {
    var courses = SavedCoursesNotifier();

    test('A new course should be added', () {
      var id = 'CM35';
      courses.add(id as Course);
      expect(courses.savedCourses.contains(id), true);
    });

    test('An course should be removed', () {
      var id = 'CM45';
      courses.add(id as Course);
      expect(courses.savedCourses.contains(id), true);
      courses.remove(id as Course);
      expect(courses.savedCourses.contains(id), false);
    });
  });
}