// File: screens/calendar_view/components/MiniCalendar.dart

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MiniCalendar extends StatelessWidget {
  /// The month the mini-calendar should show
  final DateTime focusedDay;

  /// Called when the user taps a date
  final void Function(DateTime selectedDay) onDateSelected;

  /// Called when the mini-calendar page (month) changes
  final void Function(DateTime newFocusedMonth) onMonthChanged;

  /// Called when the top “✕” is pressed
  final VoidCallback onClose;

  const MiniCalendar({
    Key? key,
    required this.focusedDay,
    required this.onDateSelected,
    required this.onMonthChanged,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      color: Colors.indigo[900],
      child: SafeArea(
        child: Column(
          children: [
            // ✕ Close button
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: onClose,
              ),
            ),

            // Black mini month calendar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Card(
                color: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: focusedDay,
                  headerStyle: HeaderStyle(
                    titleCentered: true,
                    leftChevronIcon:
                    const Icon(Icons.chevron_left, color: Colors.white),
                    rightChevronIcon:
                    const Icon(Icons.chevron_right, color: Colors.white),
                    titleTextStyle:
                    const TextStyle(color: Colors.white, fontSize: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[850],
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12)),
                    ),
                  ),
                  calendarStyle: CalendarStyle(
                    defaultTextStyle: const TextStyle(color: Colors.white70),
                    weekendTextStyle: const TextStyle(color: Colors.redAccent),
                    todayDecoration: const BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    outsideDaysVisible: false,
                  ),
                  selectedDayPredicate: (day) => isSameDay(day, focusedDay),

                  // when the user swipes or taps the chevrons in the mini-calendar
                  onPageChanged: (newFocusedDay) {
                    onMonthChanged(newFocusedDay);
                  },

                  // tapping a day
                  onDaySelected: (selected, _) {
                    onDateSelected(selected);
                  },
                ),
              ),
            ),

            const SizedBox(height: 16),

            // User avatars + “+”
            Column(
              children: [
                for (final url in [
                  'https://i.pravatar.cc/100?img=5',
                  'https://i.pravatar.cc/100?img=6',
                  'https://i.pravatar.cc/100?img=7',
                ])
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage(url),
                    ),
                  ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline,
                      size: 32, color: Colors.white70),
                  onPressed: () {
                    // your “add person” action
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Sections
            _buildSection("My Calendars", [
              _buildToggle("Daily Tasks", true),
              _buildToggle("Birthdays", false),
              _buildToggle("Tasks", true),
            ]),
            _buildSection("Favorites", [
              const ListTile(
                title: Text("— None —",
                    style: TextStyle(color: Colors.white54)),
              )
            ]),
            _buildSection("Categories", [
              _buildCategory("Work"),
              _buildCategory("Personal"),
              _buildCategory("Education"),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return ExpansionTile(
      title: Text(title,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold)),
      iconColor: Colors.white70,
      collapsedIconColor: Colors.white70,
      children: children,
    );
  }

  Widget _buildToggle(String label, bool value) {
    return CheckboxListTile(
      value: value,
      onChanged: (_) {},
      activeColor: Colors.orangeAccent,
      title: Text(label, style: const TextStyle(color: Colors.white70)),
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  Widget _buildCategory(String name) {
    return ListTile(
      leading: const Icon(Icons.label_outline, color: Colors.white70),
      title: Text(name, style: const TextStyle(color: Colors.white70)),
    );
  }
}
