import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'ViewDay.dart';
import 'ViewMonth.dart';
import 'ViewWeek.dart';
import '../sidebar/SidebarView.dart';
import '../components/MiniCalendar.dart';

/// Simple Meeting model & DataSource for SfCalendar
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
  @override DateTime getStartTime(int i) => appointments![i].from;
  @override DateTime getEndTime(int i)   => appointments![i].to;
  @override String   getSubject(int i)   => appointments![i].title;
  @override Color    getColor(int i)     => appointments![i].color;
}

class CalendarWindow extends StatefulWidget {
  const CalendarWindow({Key? key}) : super(key: key);
  @override State<CalendarWindow> createState() => _CalendarWindowState();
}

class _CalendarWindowState extends State<CalendarWindow> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _sfController = CalendarController();
  DateTime _miniFocused = DateTime.now();

  /// We’ll map these 3 to the three view‐widgets below
  static const List<CalendarView> _views = [
    CalendarView.month,
    CalendarView.week,
    CalendarView.day,
  ];
  CalendarView _currentView = CalendarView.week;

  late final MeetingDataSource _dataSource;
  final _meetings = [
    Meeting(
      "UX Review",
      DateTime.now().subtract(Duration(hours: 1)),
      DateTime.now().add(Duration(hours: 1)),
      Colors.purpleAccent,
    ),
    Meeting(
      "Standup",
      DateTime.now().add(Duration(hours: 2)),
      DateTime.now().add(Duration(hours: 3)),
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
              child: const Text("Close"),
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

  /// Return the appropriate child‐widget per [_currentView]
  Widget _buildCalendarView() {
    switch (_currentView) {
      case CalendarView.month:
        return ViewMonth(
          controller: _sfController,
          dataSource: _dataSource,
          onTap: _onSfTap,
        );
      case CalendarView.week:
        return ViewWeek(
          controller: _sfController,
          dataSource: _dataSource,
          onTap: _onSfTap,
        );
      case CalendarView.day:
        return ViewDay(
          controller: _sfController,
          dataSource: _dataSource,
          onTap: _onSfTap,
        );
      default:
        return ViewMonth(
          controller: _sfController,
          dataSource: _dataSource,
          onTap: _onSfTap,
        );
    }
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
            Text("Everything at one Place",
                style: TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
        backgroundColor: Colors.black87,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
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
        onMonthChanged: (m) => _jumpTo(m),
        onClose: () => Navigator.of(context).pop(),
      ),
      body: Column(
        children: [
          // ─── TOP BAR ──────────────────────────────────────────────────────
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
                  child: const Text("Today",
                      style: TextStyle(color: Colors.deepPurple)),
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
                    fillColor: Colors.indigo,
                    selectedColor: Colors.white,
                    color: Colors.black87,
                    constraints: const BoxConstraints(minWidth: 60, minHeight: 36),
                    isSelected: _views.map((v) => v == _currentView).toList(),
                    onPressed: (idx) {
                      setState(() {
                        _currentView = _views[idx];
                        _sfController.view = _currentView;
                      });
                    },
                    children: const [
                      Text("Month"),
                      Text("Week"),
                      Text("Day"),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ─── CALENDAR ITSELF ─────────────────────────────────────────────
          Expanded(
            child: _buildCalendarView(),
          ),
        ],
      ),
    );
  }
}
