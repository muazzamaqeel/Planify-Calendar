import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class EventList extends StatelessWidget {
  final List<String> events;
  const EventList({Key? key, required this.events}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return const Center(child: Text("No events yet, add some!"));
    }
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        return GFListTile(
          titleText: events[index],
          avatar: const GFAvatar(
            backgroundColor: Colors.red,
            child: Icon(Icons.event, color: Colors.white),
          ),
        );
      },
    );
  }
}
