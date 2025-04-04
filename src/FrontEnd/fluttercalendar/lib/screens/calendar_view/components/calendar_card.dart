import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarCard extends StatelessWidget {
  final DateTime selectedDay;
  final CalendarFormat calendarFormat;
  final Map<DateTime, List<String>> events;
  final Function(DateTime) onDaySelected;
  final Function(CalendarFormat) onFormatChanged;

  const CalendarCard({
    super.key,
    required this.selectedDay,
    required this.calendarFormat,
    required this.events,
    required this.onDaySelected,
    required this.onFormatChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: TableCalendar(
        focusedDay: selectedDay,
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        calendarFormat: calendarFormat,
        selectedDayPredicate: (day) => isSameDay(day, selectedDay),
        onDaySelected: (selectedDay, focusedDay) => onDaySelected(selectedDay),
        onFormatChanged: (format) => onFormatChanged(format),
        eventLoader: (day) => events[day] ?? [],
      ),
    );
  }
}
