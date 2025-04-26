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
    Key? key,
    required this.focusedDay,
    required this.onDateSelected,
    required this.onMonthChanged,
    required this.onClose,
  }) : super(key: key);

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
                      color: Colors.deepPurple,
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
                      color: Colors.deepPurple,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.white,
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
                      color: Colors.deepPurple,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Icon(Icons.add, color: Colors.white, size: 28),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Sections
              _buildSection(
                title: "My Calendars",
                children: [
                  _buildToggle("Daily Tasks", true),
                  _buildToggle("Birthdays", false),
                  _buildToggle("Tasks", true),
                ],
              ),
              _buildSection(
                title: "Favorites",
                children: [
                  Text(
                    "— None —",
                    style: TextStyle(color: Colors.white54),
                  ),
                ],
              ),
              _buildSection(
                title: "Categories",
                children: [
                  _buildCategory("Work"),
                  _buildCategory("Personal"),
                  _buildCategory("Education"),
                ],
              ),

              const SizedBox(height: 24),

              // Avatars row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (final url in [
                    'https://i.pravatar.cc/100?img=5',
                    'https://i.pravatar.cc/100?img=6',
                    'https://i.pravatar.cc/100?img=7',
                  ])
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: CircleAvatar(
                        radius: 16,
                        backgroundImage: NetworkImage(url),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Color(0xFF2A2A3D),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ExpansionTile(
        title: Text(
          title,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconColor: Colors.white70,
        collapsedIconColor: Colors.white70,
        childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: children,
      ),
    );
  }

  Widget _buildToggle(String label, bool value) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: (_) {},
          activeColor: Colors.deepPurpleAccent,
          fillColor: MaterialStateProperty.all(Colors.white),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: TextStyle(color: Colors.white70),
          ),
        ),
      ],
    );
  }

  Widget _buildCategory(String name) {
    return Row(
      children: [
        Icon(Icons.label_outline, color: Colors.white70, size: 20),
        SizedBox(width: 8),
        Expanded(
          child: Text(name, style: TextStyle(color: Colors.white70)),
        ),
      ],
    );
  }
}