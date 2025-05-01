import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MiniCalendar extends StatelessWidget {
  /// Currently focused month
  final DateTime focusedDay;
  /// When a day is tapped
  final void Function(DateTime) onDateSelected;
  /// When user navigates months
  final void Function(DateTime) onMonthChanged;
  /// Close drawer
  final VoidCallback onClose;

  const MiniCalendar({
    super.key,
    required this.focusedDay,
    required this.onDateSelected,
    required this.onMonthChanged,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      color: Color(0xFF1E1E2E),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Close Button
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: onClose,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.indigo,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Icon(Icons.close, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Calendar
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: focusedDay,
                  headerStyle: HeaderStyle(
                    titleCentered: true,
                    leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
                    rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white),
                    titleTextStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    formatButtonVisible: false,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                    ),
                  ),
                  calendarStyle: CalendarStyle(
                    defaultTextStyle: TextStyle(color: Colors.white70),
                    weekendTextStyle: TextStyle(color: Colors.redAccent),
                    todayDecoration: BoxDecoration(
                      color: Colors.indigo,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.indigo,
                      shape: BoxShape.circle,
                    ),
                    outsideDaysVisible: false,
                    cellMargin: EdgeInsets.zero,
                  ),
                  headerVisible: true,
                  daysOfWeekVisible: true,
                  selectedDayPredicate: (day) => isSameDay(day, focusedDay),
                  onDaySelected: (day, _) => onDateSelected(day),
                  onPageChanged: onMonthChanged,
                ),
              ),

              const SizedBox(height: 24),

              // Add Person Button
              Center(
                child: InkWell(
                  onTap: () {},
                  customBorder: CircleBorder(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.indigo,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Icon(Icons.add, color: Colors.white, size: 28),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



}