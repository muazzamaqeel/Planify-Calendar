import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarCard extends StatelessWidget {
  final DateTime selectedDay;
  final CalendarFormat calendarFormat;
  final Map<DateTime, List<String>> events;
  final void Function(DateTime) onDaySelected;
  final void Function(CalendarFormat) onFormatChanged;

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
      child: TableCalendar<String>(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: selectedDay,
        selectedDayPredicate: (day) => isSameDay(selectedDay, day),
        calendarFormat: calendarFormat,
        onFormatChanged: onFormatChanged,
        eventLoader: (day) => events[day] ?? [],
        onDaySelected: (selected, focused) => onDaySelected(selected),
        headerStyle: HeaderStyle(
          titleCentered: true,
          formatButtonVisible: true,
          formatButtonDecoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(8.0),
          ),
          formatButtonTextStyle: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: Theme.of(context).colorScheme.onSecondary),
          titleTextStyle: Theme.of(context).textTheme.headlineMedium!,
          leftChevronIcon: Icon(Icons.chevron_left,
              color: Theme.of(context).colorScheme.onSurface),
          rightChevronIcon: Icon(Icons.chevron_right,
              color: Theme.of(context).colorScheme.onSurface),
        ),
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          todayDecoration: BoxDecoration(
            color: Theme.of(context)
                .colorScheme
                .primary
                .withAlpha((0.2 * 255).toInt()),
            shape: BoxShape.circle,
          ),
          todayTextStyle: Theme.of(context).textTheme.bodyLarge!,
          selectedDecoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            shape: BoxShape.circle,
          ),
          selectedTextStyle: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary),
          weekendTextStyle: TextStyle(
              color: Theme.of(context).colorScheme.error),
        ),
      ),
    );
  }
}
