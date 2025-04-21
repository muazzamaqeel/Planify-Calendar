import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../main_view/MainWindow.dart';
import 'components/CalendarCard.dart';
import 'components/EventList.dart';
import 'notification_handler/NotificationsWindow.dart'; // Notifications overlay
import 'sidebar/sidebar_view.dart'; // Side bar code

class CalendarWindow extends StatefulWidget {
  const CalendarWindow({super.key});

  @override
  State<CalendarWindow> createState() => _CalendarWindowState();
}

class _CalendarWindowState extends State<CalendarWindow> {
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  final Map<DateTime, List<String>> _events = {};
  int _counter = 0;

  void _onDaySelected(DateTime selectedDay) {
    setState(() {
      _selectedDay = selectedDay;
    });
  }

  void _onFormatChanged(CalendarFormat format) {
    setState(() {
      _calendarFormat = format;
    });
  }

  void _addEvent() {
    setState(() {
      if (_events[_selectedDay] == null) {
        _events[_selectedDay] = [];
      }
      _events[_selectedDay]!.add(
        "Event at ${DateFormat('hh:mm a').format(DateTime.now())}",
      );
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        // Combined title that preserves both branches' naming
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Planify",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              "Modern Flutter Calendar",
              style: TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Show the overlay from NotificationsWindow
              NotificationsWindow.showNotificationOverlay(context);
            },
          ),
        ],
      ),
      // Use the side bar from sidebar_view.dart
      drawer: const SideBarView(),
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
            child: EventList(
              events: _events[_selectedDay] ?? [],
            ),
          ),
        ],
      ),
      // Floating action buttons for adding events and incrementing a counter
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: 'addEvent', // Unique tag for the Add Event button
            onPressed: _addEvent,
            label: const Text("Add Event"),
            icon: const Icon(Icons.add),
            backgroundColor: Colors.orange,
          ),
          const SizedBox(height: 10),
          FloatingActionButton.extended(
            heroTag: 'incrementCounter', // Unique tag for the Counter button
            onPressed: _incrementCounter,
            label: Text("Count: $_counter"),
            icon: const Icon(Icons.add_circle_outline),
            backgroundColor: Colors.deepPurple,
          ),
        ],
      ),
    );
  }
}
