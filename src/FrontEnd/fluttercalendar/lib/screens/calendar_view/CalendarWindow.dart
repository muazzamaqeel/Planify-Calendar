import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../main_view/MainWindow.dart';
import 'components/calendar_card.dart';
import 'components/event_list.dart';

class CalendarWindow extends StatefulWidget {
  const CalendarWindow({Key? key}) : super(key: key);

  @override
  State<CalendarWindow> createState() => _CalendarWindowState();
}

class _CalendarWindowState extends State<CalendarWindow> {
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  final Map<DateTime, List<String>> _events = {};
  int _counter = 0;

  // Called when a user selects a day on the calendar
  void _onDaySelected(DateTime selectedDay) {
    setState(() {
      _selectedDay = selectedDay;
    });
  }

  // Called when the user changes between Month/2-weeks/Week format
  void _onFormatChanged(CalendarFormat format) {
    setState(() {
      _calendarFormat = format;
    });
  }

  // Adds a new event to the selected day
  void _addEvent() {
    setState(() {
      _events[_selectedDay] ??= [];
      _events[_selectedDay]!.add(
        "Event at ${DateFormat('hh:mm a').format(DateTime.now())}",
      );
    });
  }

  // Simple counter increment
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  // Jump back to today's date
  void _goToToday() {
    setState(() {
      _selectedDay = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Subtle grey background for a modern, cohesive look
      backgroundColor: Colors.grey[200],

      // Darker app bar for contrast
      appBar: GFAppBar(
        title: const Text(
          "Planify",
          // Making the text also bold and white for better visibility
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
            ),
          ),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      // Dark-themed navigation drawer
      drawer: Drawer(
        backgroundColor: Colors.blueGrey[700],
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blueGrey[800]),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Hello, Aida!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today, color: Colors.white),
              title:
                  const Text('Calendar', style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.event, color: Colors.white),
              title:
                  const Text('Events', style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.white),
              title:
                  const Text('Settings', style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const MainWindow()),
                    (Route<dynamic> route) => false, // removes all previous routes
                  );
                  // Removed Navigator.popUntil call as it causes error when the route stack is empty.
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
              ),
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          // Calendar UI widget
          CalendarCard(
            selectedDay: _selectedDay,
            calendarFormat: _calendarFormat,
            events: _events,
            onDaySelected: _onDaySelected,
            onFormatChanged: _onFormatChanged,
          ),

          // Event list for the selected day
          Expanded(
            child: Container(
              color: Colors.grey[100],
              child: EventList(
                events: _events[_selectedDay] ?? [],
              ),
            ),
          ),
        ],
      ),

      // Modern floating action buttons for adding events, counting, and going to "Today"
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: 'addEvent', // Unique tag for the Add Event button from CA1234
            onPressed: _addEvent,
            label: const Text("Add Event"),
            icon: const Icon(Icons.add),
            backgroundColor: Colors.orange,
          ),
          const SizedBox(height: 10),
          FloatingActionButton.extended(
            heroTag: 'incrementCounter',
            onPressed: _incrementCounter,
            label: Text("Count: $_counter"),
            icon: const Icon(Icons.add_circle_outline),
            backgroundColor: Colors.deepPurple,
          ),
          const SizedBox(height: 10),
          FloatingActionButton.extended(
            heroTag: 'goToToday',
            onPressed: _goToToday,
            label: const Text("Today"),
            icon: const Icon(Icons.today),
            backgroundColor: Colors.deepPurple,
          ),
        ],
      ),
    );
  }
}
