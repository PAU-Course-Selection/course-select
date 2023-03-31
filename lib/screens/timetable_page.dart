import 'package:course_select/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Timetable extends StatelessWidget {
  const Timetable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                Padding(
                  padding:  EdgeInsets.only(
                    bottom: 10.0.h,
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
                              children: const [
                                Text(
                                  'Design Patterns',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '8:00 - 8:45',
                                  style: TextStyle(color: Colors.grey),
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
                    width: double.infinity,
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
    meetings.add(Meeting('Introduction to Design Patterns', startTime, endTime,
        const Color(0xFF0F8644), false));
    meetings.add(Meeting(
        'UX/UI Design', startTime, endTime, const Color(0xFF245953), false));
    meetings.add(Meeting('Software Testing', startTime, endTime,
        const Color(0xFF408E91), false));
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
