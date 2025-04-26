// lib/screens/calendar_view/calendar_window.dart

import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'sidebar/SidebarView.dart';
import 'components/MiniCalendar.dart';  // your new mini-calendar component

// Simple Meeting class & DataSource
class Meeting {
  Meeting(this.title, this.from, this.to, this.color);
  final String title;
  final DateTime from, to;
  final Color color;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) { appointments = source; }

  @override
  DateTime getStartTime(int index) => appointments![index].from;
  @override
  DateTime getEndTime(int index)   => appointments![index].to;
  @override
  String getSubject(int index)     => appointments![index].title;
  @override
  Color  getColor(int index)       => appointments![index].color;
}

class CalendarWindow extends StatefulWidget {
  const CalendarWindow({Key? key}) : super(key: key);
  @override
  State<CalendarWindow> createState() => _CalendarWindowState();
}

class _CalendarWindowState extends State<CalendarWindow> {
  // scaffold key so we can open/close both drawers
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  // controller for the main Syncfusion calendar
  final CalendarController _sfController = CalendarController();

  // what month mini-calendar is showing
  DateTime _miniFocused = DateTime.now();

  // month/week/day
  CalendarView _currentView = CalendarView.week;

  // some sample meetings
  late MeetingDataSource _dataSource;
  final _meetings = [
    Meeting("UX Review", DateTime.now().subtract(const Duration(hours:1)),
        DateTime.now().add(const Duration(hours:1)),
        Colors.purpleAccent),
    Meeting("Standup",   DateTime.now().add(const Duration(hours:2)),
        DateTime.now().add(const Duration(hours:3)),
        Colors.teal),
  ];

  @override
  void initState() {
    super.initState();
    _dataSource = MeetingDataSource(_meetings);
  }

  // show details when tapping an appointment
  void _onSfTap(CalendarTapDetails details) {
    if (details.targetElement == CalendarElement.appointment &&
        details.appointments != null) {
      final m = details.appointments!.first as Meeting;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(m.title),
          content: Text(
              "${DateFormat.jm().format(m.from)} – ${DateFormat.jm().format(m.to)}"
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close")
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,

      // <-- left drawer
      drawer: const SideBarView(),

      // top bar with hamburger + notifications + calendar icon
      appBar: GFAppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("Planify",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                )),
            Text("Modern Flutter Calendar",
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12
                )),
          ],
        ),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        // hamburger is automatic, these are extra action buttons:
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // your NotificationsWindow.showNotificationOverlay(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () =>
                _scaffoldKey.currentState!.openEndDrawer(),
          ),
        ],
      ),

      // <-- right drawer = mini-calendar
      endDrawer: MiniCalendar(
        focusedDay: _miniFocused,
        onDateSelected: (DateTime day) {
          setState(() {
            _miniFocused = day;
            // jump the SfCalendar to this date:
            _sfController.displayDate = day;
          });
          Navigator.of(context).pop(); // close the endDrawer
        },
        onClose: () {
          Navigator.of(context).pop(); // close the endDrawer
        },
      ),

      // main content
      body: Column(
        children: [
          // gradient header + month navigation + toggles
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(
                horizontal: 24, vertical: 16
            ),
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
                  offset: Offset(0,4),
                )
              ],
            ),
            child: Row(
              children: [
                Text(
                  DateFormat.yMMMM().format(_miniFocused),
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    _sfController.displayDate = DateTime.now();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8
                    ),
                  ),
                  child: const Text("Today",
                      style: TextStyle(color: Colors.deepPurple)
                  ),
                ),
                const SizedBox(width: 24),
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    final cur = _sfController.displayDate ?? DateTime.now();
                    _sfController.displayDate =
                        DateTime(cur.year, cur.month - 1, 1);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {
                    final cur = _sfController.displayDate ?? DateTime.now();
                    _sfController.displayDate =
                        DateTime(cur.year, cur.month + 1, 1);
                  },
                ),
                const Spacer(),
                ToggleButtons(
                  borderRadius: BorderRadius.circular(20),
                  fillColor: Colors.deepPurple,
                  selectedColor: Colors.white,
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal:12),
                      child: Text("Month"),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal:12),
                      child: Text("Week"),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal:12),
                      child: Text("Day"),
                    ),
                  ],
                  isSelected: [
                    _currentView == CalendarView.month,
                    _currentView == CalendarView.week,
                    _currentView == CalendarView.day,
                  ],
                  onPressed: (idx) {
                    setState(() {
                      _currentView = [
                        CalendarView.month,
                        CalendarView.week,
                        CalendarView.day
                      ][idx];
                    });
                  },
                ),
              ],
            ),
          ),

          // the Syncfusion calendar
          Expanded(
            child: SfCalendar(
              controller: _sfController,
              view: _currentView,
              dataSource: _dataSource,
              monthViewSettings: const MonthViewSettings(
                appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
              ),
              timeSlotViewSettings: const TimeSlotViewSettings(
                startHour: 6,
                endHour: 20,
                timeInterval: Duration(minutes:30),
              ),
              onTap: _onSfTap,
              firstDayOfWeek: 1,
            ),
          ),
        ],
      ),
    );
  }
}
