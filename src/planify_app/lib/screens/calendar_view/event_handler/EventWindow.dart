import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventWindow extends StatelessWidget {
  final DateTime date;
  final List<String> events;
  final void Function(String) onEventTap;

  const EventWindow({
    Key? key,
    required this.date,
    required this.events,
    required this.onEventTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formatted = DateFormat.yMMMMd().format(date);
    if (events.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.event_busy,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              "No events on $formatted",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Tap the + button to add your first event",
              style: TextStyle(color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: events.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (ctx, i) {
        final desc = events[i];
        // Extract time from description if present, else default icon
        final timeMatch = RegExp(r'\d{1,2}:\d{2} [AP]M')
            .firstMatch(desc);
        final timeLabel = timeMatch?.group(0) ?? '';

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              backgroundColor: Colors.deepPurple,
              child: Text(
                timeLabel.isNotEmpty
                    ? timeLabel.split(' ')[0]
                    : '•',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              desc,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => onEventTap(desc),
          ),
        );
      },
    );
  }
}
