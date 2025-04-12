import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/theme_notifier.dart';

class SettingsView {
  /// Displays an overlay with a modern settings interface containing several options.
  static void showSettingsOverlay(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true, // Allow dismissal by tapping outside.
      barrierLabel: 'Settings', // Accessibility label.
      barrierColor: Colors.black54, // Semi-transparent background.
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Material(
            color:
                Colors.transparent, // Keep the overlay background transparent.
            child: Container(
              width: 400,
              height: 500,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.account_circle),
                          title: const Text('Account'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {},
                        ),
                        ListTile(
                          leading: const Icon(Icons.notifications),
                          title: const Text('Notifications'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {},
                        ),
                        ListTile(
                          leading: const Icon(Icons.security),
                          title: const Text('Privacy & Security'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {},
                        ),

                        // Theme Selection Dialog
                        ListTile(
                          leading: const Icon(Icons.color_lens),
                          title: const Text('Theme'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Choose Theme'),
                                  content: Consumer<ThemeNotifier>(
                                    builder: (context, notifier, child) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          RadioListTile<bool>(
                                            title: const Text('Light Mode'),
                                            value: false,
                                            groupValue: notifier.isDarkMode,
                                            onChanged: (value) {
                                              notifier.setTheme(false);
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          RadioListTile<bool>(
                                            title: const Text('Dark Mode'),
                                            value: true,
                                            groupValue: notifier.isDarkMode,
                                            onChanged: (value) {
                                              notifier.setTheme(true);
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                );
                              },
                            );
                          },
                        ),

                        ListTile(
                          leading: const Icon(Icons.language),
                          title: const Text('Language'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {},
                        ),
                        ListTile(
                          leading: const Icon(Icons.info),
                          title: const Text('About'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close Settings'),
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
