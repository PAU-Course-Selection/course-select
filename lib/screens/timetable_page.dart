import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_select/constants/constants.dart';
import 'package:course_select/controllers/lesson_notifier.dart';
import 'package:course_select/utils/firebase_data_management.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../controllers/user_notifier.dart';
import '../models/lesson_data_model.dart';

class Timetable extends StatefulWidget {
  const Timetable({Key? key}) : super(key: key);

  @override
  State<Timetable> createState() => _TimetableState();
}

class _TimetableState extends State<Timetable> {
  final DatabaseManager _db = DatabaseManager();
  late final LessonNotifier lessonNotifier;
  late final UserNotifier userNotifier;
  late List<Lesson> lessons = [];
  var courses;


  @override
  void initState() {
    super.initState();
    lessonNotifier = Provider.of<LessonNotifier>(context, listen: false);
    userNotifier = Provider.of<UserNotifier>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      courses = userNotifier.getCourseIds();
      getLessons();
    });
  }

  getLessons() async {
    await _db.getUserLessons(courses,lessonNotifier, userNotifier)
        .then((value) {
          setState(() {
            lessons = value;
          });
    });
    // await _db.updateLessonDates(courses);
  }

  @override
  Widget build(BuildContext context) {
    // print(lessons);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Schedule',
          style: kHeadlineMedium,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
          child: SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.85.h,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text(
                        'Lessons',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Flexible(
                        child: Text('3 lessons today'),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 160.h,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: lessonNotifier.userLessonsList.length,
                      itemBuilder: (context,index){
                        return LessonCard(title: lessonNotifier.userLessonsList[index].lessonName,
                          startTime: DateFormat.Hm().format(lessonNotifier.userLessonsList[index].startTime!.toDate()),
                          endTime: DateFormat.Hm().format(lessonNotifier.userLessonsList[index].endTime!.toDate()));
                      }
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 20.0,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: kLightBackground.withOpacity(0.2),
                      ),
                      child: SfCalendar(
                        view: CalendarView.week,
                        showNavigationArrow: true,
                        todayHighlightColor: kPrimaryColour,
                        selectionDecoration: BoxDecoration(
                          border: Border.all(color: kPrimaryColour, width: 2),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4)),
                          shape: BoxShape.rectangle,
                        ),
                        dataSource: MeetingDataSource(_getDataSource()),
                        monthViewSettings: const MonthViewSettings(
                            showAgenda: true,
                            appointmentDisplayMode:
                                MonthAppointmentDisplayMode.indicator),
                      ),
                      width: double.infinity,
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Meeting> _getDataSource() {
    final List<Meeting> meetings = <Meeting>[];
    final DateTime today = DateTime.now();
    final DateTime startTime = DateTime(today.year, today.month, today.day, 9);
    final DateTime endTime = startTime.add(const Duration(hours: 2));

    for(var lesson in lessons){
      var startTime = lesson.startTime?.toDate();
      var endTime = lesson.endTime?.toDate();
      meetings.add(Meeting(lesson.lessonName, startTime!, endTime!,
          const Color(0xFF0F8644), false));
    }
    return meetings;
  }
}

/// An object to set the appointment collection data source to calendar, which
/// used to map the custom appointment data to the calendar appointment, and
/// allows to add, remove or reset the appointment collection.
class MeetingDataSource extends CalendarDataSource {
  /// Creates a meeting data source, which used to set the appointment
  /// collection to the calendar
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getMeetingData(index).from;
  }

  @override
  DateTime getEndTime(int index) {
    return _getMeetingData(index).to;
  }

  @override
  String getSubject(int index) {
    return _getMeetingData(index).eventName;
  }

  @override
  Color getColor(int index) {
    return _getMeetingData(index).background;
  }

  @override
  bool isAllDay(int index) {
    return _getMeetingData(index).isAllDay;
  }

  Meeting _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    late final Meeting meetingData;
    if (meeting is Meeting) {
      meetingData = meeting;
    }

    return meetingData;
  }
}

/// Custom business object class which contains properties to hold the detailed
/// information about the event data which will be rendered in calendar.
class Meeting {
  /// Creates a meeting class with required details.
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  /// Event name which is equivalent to subject property of [Appointment].
  String eventName;

  /// From which is equivalent to start time property of [Appointment].
  DateTime from;

  /// To which is equivalent to end time property of [Appointment].
  DateTime to;

  /// Background which is equivalent to color property of [Appointment].
  Color background;

  /// IsAllDay which is equivalent to isAllDay property of [Appointment].
  bool isAllDay;
}
class LessonCard extends StatelessWidget {
  final String? title;
  final String startTime;
  final String endTime;
  const LessonCard({
    Key? key, required this.title, required this.startTime, required this.endTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(
          bottom: 10.0.h, right: 10.h
      ),
      child: Container(
        height: 160.h,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: const Color(0xffe2e4e3)),
        child: Stack(
          children: [
            Positioned(
              top: 5,
              child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(75.0),
                      child: ImageIcon(
                        const AssetImage(
                            'assets/images/teacher.png'),
                        color: kTeal,
                      ))),
            ),
            Positioned(
                left: 60,
                top: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:  [
                    Text(
                      title!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      width: 100.w,
                      child: Text(
                        '$startTime - $endTime',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    )
                  ],
                )),
            Positioned(
                top: 60,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Join Now'),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        const Color(0xff408E91),
                      ),
                      elevation: MaterialStateProperty.all(0),
                      shape: MaterialStateProperty.all<
                          RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(10.0)))),
                )),
            Positioned(
                top: 0,
                right: 10,
                width: 110,
                child: Image.asset('assets/images/class6.png')),
          ],
        ),
        width: MediaQuery.of(context).size.width * 0.80,
      ),
    );
  }
}