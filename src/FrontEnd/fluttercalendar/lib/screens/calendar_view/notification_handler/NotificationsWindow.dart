import 'package:flutter/material.dart';

class NotificationsWindow {
  /// Shows a semi-transparent overlay dialog with dummy notifications.
  static void showNotificationOverlay(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,        // Allow dismiss on tap outside
      barrierLabel: 'Notifications',   // Used for accessibility
      barrierColor: Colors.black54,    // Semi-transparent dark background
      pageBuilder: (ctx, anim1, anim2) {
        return Center(
          child: Material(
            color: Colors.transparent,  // Keep background transparent
            child: Container(
              width: 300,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Dummy notifications
                  const Text('Dummy Notification #1'),
                  const Text('Dummy Notification #2'),
                  const Text('Dummy Notification #3'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
