import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import 'components/calendar_card.dart';
import 'components/event_list.dart';


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
        title: const Text("Modern Flutter Calendar"),
        backgroundColor: Colors.deepPurple,
      ),
      // Sidebar navigation drawer
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.deepPurple),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Hello, User!',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Calendar'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.event),
              title: const Text('Events'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.popUntil(context, ModalRoute.withName('/'));
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
