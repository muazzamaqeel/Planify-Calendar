import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ViewMonth extends StatelessWidget {
  final CalendarController controller;
  final CalendarDataSource dataSource;
  final CalendarTapCallback onTap;

  const ViewMonth({
    Key? key,
    required this.controller,
    required this.dataSource,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      controller: controller,
      view: CalendarView.month,
      dataSource: dataSource,
      monthViewSettings: const MonthViewSettings(
        appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
      ),
      onTap: onTap,
      firstDayOfWeek: 1,
    );
  }
}
