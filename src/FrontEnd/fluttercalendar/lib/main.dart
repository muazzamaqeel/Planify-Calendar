import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Modern Flutter Calendar',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Modern Calendar App'),
    );
  }
}

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
  Map<DateTime, List<String>> _events = {}; // Store events

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _addEvent() {
    setState(() {
      if (_events[_selectedDay] == null) {
        _events[_selectedDay] = [];
      }
      _events[_selectedDay]!
          .add("Event at ${DateFormat('hh:mm a').format(DateTime.now())}");
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
          // 🎨 Modern Calendar UI
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GFCard(
              boxFit: BoxFit.cover,
              title: GFListTile(
                avatar: const GFAvatar(
                  backgroundColor: Colors.deepPurple,
                  child: Icon(Icons.calendar_today, color: Colors.white),
                ),
                title: Text(
                  "Selected Date: ${DateFormat('yMMMMd').format(_selectedDay)}",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subTitle: Text(
                  "Tap on a date to add events",
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              ),
              content: TableCalendar(
                focusedDay: _selectedDay,
                firstDay: DateTime.utc(2000, 1, 1),
                lastDay: DateTime.utc(2100, 12, 31),
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                  });
                },
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                eventLoader: (day) => _events[day] ?? [],
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
          ),

          // 📅 Event List
          Expanded(
            child:
                _events[_selectedDay] == null || _events[_selectedDay]!.isEmpty
                    ? const Center(child: Text("No events yet, add some!"))
                    : ListView.builder(
                        itemCount: _events[_selectedDay]!.length,
                        itemBuilder: (context, index) {
                          return GFListTile(
                            titleText: _events[_selectedDay]![index],
                            avatar: const GFAvatar(
                              backgroundColor: Colors.red,
                              child: Icon(Icons.event, color: Colors.white),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),

      // 🌟 Floating Action Buttons
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Add Event Button
          FloatingActionButton.extended(
            onPressed: _addEvent,
            label: const Text("Add Event"),
            icon: const Icon(Icons.add),
            backgroundColor: Colors.orange,
          ),
          const SizedBox(height: 10),
          // Counter Button
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
