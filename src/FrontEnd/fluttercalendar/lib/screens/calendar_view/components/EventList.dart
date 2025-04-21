import 'package:flutter/material.dart';

class EventList extends StatelessWidget {
  final List<String> events;

  const EventList({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return const Center(
        child: Text('No events for this day'),
      );
    }
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.event),
          title: Text(events[index]),
        );
      },
    );
  }
}
