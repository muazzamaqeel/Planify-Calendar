import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'components/MiniCalendar.dart';
import 'event_handler/EventWindow.dart';

class Meeting {
  Meeting(this.title, this.from, this.to, this.color);
  final String title;
  final DateTime from, to;
  final Color color;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) => appointments![index].from;
  @override
  DateTime getEndTime(int index) => appointments![index].to;
  @override
  String getSubject(int index) => appointments![index].title;
  @override
  Color getColor(int index) => appointments![index].color;
}

class CalendarWindow extends StatefulWidget {
  const CalendarWindow({Key? key}) : super(key: key);

  @override
  _CalendarWindowState createState() => _CalendarWindowState();
}

class _CalendarWindowState extends State<CalendarWindow> {
  // Controller for the right‐hand SfCalendar
  final CalendarController _sfController = CalendarController();

  // What month the mini calendar shows & what date SfCalendar should jump to
  DateTime _miniFocused = DateTime.now();

  // Month/week/day
  CalendarView _currentView = CalendarView.week;

  // Sample data
  late MeetingDataSource _dataSource;
  final _meetings = [
    Meeting(
      "UX Review",
      DateTime.now().subtract(const Duration(hours: 1)),
      DateTime.now().add(const Duration(hours: 1)),
      Colors.purpleAccent,
    ),
    Meeting(
      "Standup",
      DateTime.now().add(const Duration(hours: 2)),
      DateTime.now().add(const Duration(hours: 3)),
      Colors.teal,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _dataSource = MeetingDataSource(_meetings);
  }

  void _onSfTap(CalendarTapDetails details) {
    if (details.targetElement == CalendarElement.appointment &&
        details.appointments != null) {
      final m = details.appointments!.first as Meeting;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(m.title),
          content: Text(
            "${DateFormat.jm().format(m.from)} — ${DateFormat.jm().format(m.to)}",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("Planify",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            Text("Modern Flutter Calendar",
                style:
                TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Row(
        children: [
          // ← Mini calendar sidebar
          MiniCalendar(
            focusedDay: _miniFocused,
            onDateSelected: (newDay) {
              setState(() {
                _miniFocused = newDay;
                // jump the Syncfusion calendar
                _sfController.displayDate = newDay;
              });
            },
            onClose: () {
              // If you want to pop the entire screen:
              Navigator.of(context).maybePop();
            },
          ),

          // → Main content
          Expanded(
            child: Column(
              children: [
                // Gradient header with Month/Week/Day
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFE3F2FD),
                        Color(0xFFF1F8E9),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Text(
                        DateFormat.yMMMM().format(_miniFocused),
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          _sfController.displayDate =
                              DateTime.now();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                        ),
                        child: const Text(
                          "Today",
                          style:
                          TextStyle(color: Colors.deepPurple),
                        ),
                      ),
                      const SizedBox(width: 24),
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        onPressed: () {
                          final cur = _sfController
                              .displayDate ??
                              DateTime.now();
                          _sfController.displayDate =
                              DateTime(cur.year,
                                  cur.month - 1, 1);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: () {
                          final cur = _sfController
                              .displayDate ??
                              DateTime.now();
                          _sfController.displayDate =
                              DateTime(cur.year,
                                  cur.month + 1, 1);
                        },
                      ),
                      const Spacer(),
                      ToggleButtons(
                        borderRadius: BorderRadius.circular(20),
                        fillColor: Colors.deepPurple,
                        selectedColor: Colors.white,
                        children: const [
                          Padding(
                            padding:
                            EdgeInsets.symmetric(horizontal: 12),
                            child: Text("Month"),
                          ),
                          Padding(
                            padding:
                            EdgeInsets.symmetric(horizontal: 12),
                            child: Text("Week"),
                          ),
                          Padding(
                            padding:
                            EdgeInsets.symmetric(horizontal: 12),
                            child: Text("Day"),
                          ),
                        ],
                        isSelected: [
                          _currentView == CalendarView.month,
                          _currentView == CalendarView.week,
                          _currentView == CalendarView.day,
                        ],
                        onPressed: (i) {
                          setState(() {
                            _currentView = [
                              CalendarView.month,
                              CalendarView.week,
                              CalendarView.day
                            ][i];
                          });
                        },
                      ),
                    ],
                  ),
                ),

                // The Syncfusion calendar
                Expanded(
                  child: SfCalendar(
                    controller: _sfController,
                    view: _currentView,
                    dataSource: _dataSource,
                    monthViewSettings:
                    const MonthViewSettings(
                      appointmentDisplayMode:
                      MonthAppointmentDisplayMode
                          .appointment,
                    ),
                    timeSlotViewSettings:
                    const TimeSlotViewSettings(
                      startHour: 6,
                      endHour: 20,
                      timeInterval:
                      Duration(minutes: 30),
                    ),
                    onTap: _onSfTap,
                    firstDayOfWeek: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
