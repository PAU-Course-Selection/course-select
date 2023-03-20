import 'package:course_select/models/saved_courses_model.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  group('Testing App Provider', () {
    var courses = SavedCourses();

    test('A new course should be added', () {
      var id = 'CM35';
      courses.add(id);
      expect(courses.savedCourses.contains(id), true);
    });

    test('An course should be removed', () {
      var id = 'CM45';
      courses.add(id);
      expect(courses.savedCourses.contains(id), true);
      courses.remove(id);
      expect(courses.savedCourses.contains(id), false);
    });
  });
}