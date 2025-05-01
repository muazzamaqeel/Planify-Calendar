import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ViewWeek extends StatelessWidget {
  final CalendarController controller;
  final CalendarDataSource dataSource;
  final CalendarTapCallback onTap;

  const ViewWeek({
    Key? key,
    required this.controller,
    required this.dataSource,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      controller: controller,
      view: CalendarView.week,
      dataSource: dataSource,
      timeSlotViewSettings: const TimeSlotViewSettings(
        startHour: 6,
        endHour: 20,
        timeInterval: Duration(minutes: 30),
      ),
      onTap: onTap,
      firstDayOfWeek: 1,
    );
  }
}
