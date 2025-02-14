import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../widgets/calendar_card.dart';
import '../widgets/event_list.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  final Map<DateTime, List<String>> _events = {};

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        title: Text(widget.title),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          // Calendar UI
          CalendarCard(
            selectedDay: _selectedDay,
            calendarFormat: _calendarFormat,
            events: _events,
            onDaySelected: _onDaySelected,
            onFormatChanged: _onFormatChanged,
          ),
          // Event List UI
          Expanded(
            child: EventList(
              events: _events[_selectedDay] ?? [],
            ),
          ),
        ],
      ),
      // Floating Action Buttons
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            onPressed: _addEvent,
            label: const Text("Add Event"),
            icon: const Icon(Icons.add),
            backgroundColor: Colors.orange,
          ),
          const SizedBox(height: 10),
          FloatingActionButton.extended(
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
