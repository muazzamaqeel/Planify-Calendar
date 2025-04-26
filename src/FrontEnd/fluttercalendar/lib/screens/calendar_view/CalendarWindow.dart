// File: screens/calendar_view/CalendarWindow.dart

import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'sidebar/SidebarView.dart';
import 'components/MiniCalendar.dart';

// Simple Meeting class & DataSource
class Meeting {
  Meeting(this.title, this.from, this.to, this.color);
  final String title;
  final DateTime from, to;
  final Color color;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) { appointments = source; }
  @override DateTime getStartTime(int i) => appointments![i].from;
  @override DateTime getEndTime(int i)   => appointments![i].to;
  @override String   getSubject(int i)   => appointments![i].title;
  @override Color    getColor(int i)     => appointments![i].color;
}

class CalendarWindow extends StatefulWidget {
  const CalendarWindow({Key? key}) : super(key: key);
  @override
  State<CalendarWindow> createState() => _CalendarWindowState();
}

class _CalendarWindowState extends State<CalendarWindow> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _sfController = CalendarController();

  DateTime _miniFocused = DateTime.now();

  // Map the 3 segments → these views:
  static const List<CalendarView> _views = [
    CalendarView.month, // Month grid
    CalendarView.week,  // Vertical week (7 days across)
    CalendarView.day,   // Day timeline
  ];

  // Start in “Week” by default
  CalendarView _currentView = CalendarView.week;

  late final MeetingDataSource _dataSource;
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
    _sfController.view = _currentView;
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

  void _jumpTo(DateTime date) {
    setState(() {
      _sfController.displayDate = date;
      _miniFocused = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,

      drawer: const SideBarView(),

      appBar: GFAppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("Planify",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            Text("Modern Flutter Calendar",
                style: TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _scaffoldKey.currentState!.openEndDrawer(),
          ),
        ],
      ),

      endDrawer: MiniCalendar(
        focusedDay: _miniFocused,
        onDateSelected: (day) {
          _jumpTo(day);
          Navigator.of(context).pop();
        },
        onMonthChanged: (month) => _jumpTo(month),
        onClose: () => Navigator.of(context).pop(),
      ),

      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE3F2FD), Color(0xFFF1F8E9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0,4))
              ],
            ),
            child: Row(
              children: [
                Text(
                  DateFormat.yMMMM().format(_miniFocused),
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => _jumpTo(DateTime.now()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  child: const Text("Today", style: TextStyle(color: Colors.deepPurple)),
                ),
                const SizedBox(width: 24),
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    final cur = _sfController.displayDate ?? DateTime.now();
                    _jumpTo(DateTime(cur.year, cur.month - 1, 1));
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {
                    final cur = _sfController.displayDate ?? DateTime.now();
                    _jumpTo(DateTime(cur.year, cur.month + 1, 1));
                  },
                ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: ToggleButtons(
                    borderWidth: 0,
                    borderRadius: BorderRadius.circular(24),
                    fillColor: Colors.deepPurple,
                    selectedColor: Colors.white,
                    color: Colors.black87,
                    constraints: const BoxConstraints(minWidth: 60, minHeight: 36),
                    children: const [
                      Text("Month"),
                      Text("Week"),
                      Text("Day"),
                    ],
                    isSelected: _views.map((v) => v == _currentView).toList(),
                    onPressed: (idx) {
                      setState(() {
                        _currentView = _views[idx];
                        _sfController.view = _currentView;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

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
                timeInterval: Duration(minutes: 30),
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
