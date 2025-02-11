import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarCard extends StatelessWidget {
  final DateTime selectedDay;
  final CalendarFormat calendarFormat;
  final Map<DateTime, List<String>> events;
  final ValueChanged<DateTime> onDaySelected;
  final ValueChanged<CalendarFormat> onFormatChanged;

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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GFCard(
        boxFit: BoxFit.cover,
        title: GFListTile(
          avatar: const GFAvatar(
            backgroundColor: Colors.deepPurple,
            child: Icon(Icons.calendar_today, color: Colors.white),
          ),
          title: Text(
            "Selected Date: ${DateFormat('yMMMMd').format(selectedDay)}",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          subTitle: Text(
            "Tap on a date to add events",
            style: TextStyle(color: Colors.grey.shade700),
          ),
        ),
        content: TableCalendar(
          focusedDay: selectedDay,
          firstDay: DateTime.utc(2000, 1, 1),
          lastDay: DateTime.utc(2100, 12, 31),
          calendarFormat: calendarFormat,
          selectedDayPredicate: (day) => isSameDay(day, selectedDay),
          onDaySelected: (selected, focused) => onDaySelected(selected),
          onFormatChanged: onFormatChanged,
          eventLoader: (day) => events[day] ?? [],
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: Colors.deepPurple,
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: Colors.orange,
              shape: BoxShape.circle,
            ),
            markerDecoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
