import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarCard extends StatelessWidget {
  final DateTime selectedDay;
  final CalendarFormat calendarFormat;
  final Map<DateTime, List<String>> events;
  final Function(DateTime) onDaySelected;
  final Function(CalendarFormat) onFormatChanged;

  const CalendarCard({
    Key? key,
    required this.selectedDay,
    required this.calendarFormat,
    required this.events,
    required this.onDaySelected,
    required this.onFormatChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: TableCalendar(
        // Basic Calendar Setup
        focusedDay: selectedDay,
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        calendarFormat: calendarFormat,
        selectedDayPredicate: (day) => isSameDay(day, selectedDay),

        // Callbacks
        onDaySelected: (selectedDay, focusedDay) => onDaySelected(selectedDay),
        onFormatChanged: (format) => onFormatChanged(format),
        eventLoader: (day) => events[day] ?? [],

        // Calendar Styles
        headerStyle: HeaderStyle(
          titleCentered: true,
          formatButtonVisible: true,
          formatButtonDecoration: BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: BorderRadius.circular(8.0),
          ),
          formatButtonTextStyle: const TextStyle(color: Colors.white),
          titleTextStyle: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
          leftChevronIcon: const Icon(Icons.chevron_left, color: Colors.black54),
          rightChevronIcon: const Icon(Icons.chevron_right, color: Colors.black54),
        ),
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          // Today styling
          todayDecoration: BoxDecoration(
            color: Colors.blueGrey.shade200,
            shape: BoxShape.circle,
          ),
          todayTextStyle: const TextStyle(color: Colors.black),
          // Selected day styling
          selectedDecoration: const BoxDecoration(
            color: Colors.deepPurple,
            shape: BoxShape.circle,
          ),
          selectedTextStyle: const TextStyle(color: Colors.white),
          weekendTextStyle: const TextStyle(color: Colors.redAccent),
        ),
      ),
    );
  }
}
