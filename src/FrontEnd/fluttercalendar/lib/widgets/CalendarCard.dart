--- a/lib/screens/calendar_view/components/CalendarCard.dart
+++ b/lib/screens/calendar_view/components/CalendarCard.dart
@@ Widget build(BuildContext context) {
-    return Card(
-      color: Colors.white,
-      elevation: 4,
-      margin: const EdgeInsets.all(16),
+    return Card(
+      // now uses CardTheme from AppTheme
child: TableCalendar(
@@
-        headerStyle: HeaderStyle(
-          titleCentered: true,
-          formatButtonVisible: true,
-          formatButtonDecoration: BoxDecoration(
-            color: Colors.deepPurple,
-            borderRadius: BorderRadius.circular(8.0),
-          ),
-          formatButtonTextStyle: const TextStyle(color: Colors.white),
-          titleTextStyle: const TextStyle(
-            color: Colors.black87,
-            fontWeight: FontWeight.bold,
-          ),
-          leftChevronIcon: const Icon(Icons.chevron_left, color: Colors.black54),
-          rightChevronIcon: const Icon(Icons.chevron_right, color: Colors.black54),
-        ),
+        headerStyle: HeaderStyle(
+          titleCentered: true,
+          formatButtonVisible: true,
+          formatButtonDecoration: BoxDecoration(
+            color: Theme.of(context).colorScheme.secondary,
+            borderRadius: AppShapes.cardRadius,
+          ),
+          formatButtonTextStyle: Theme.of(context).textTheme.bodyText1!
+            .copyWith(color: Theme.of(context).colorScheme.onSecondary),
+          titleTextStyle: Theme.of(context).textTheme.headline2!,
+          leftChevronIcon: Icon(Icons.chevron_left,
+            color: Theme.of(context).colorScheme.onBackground),
+          rightChevronIcon: Icon(Icons.chevron_right,
+            color: Theme.of(context).colorScheme.onBackground),
+        ),
@@
-        calendarStyle: CalendarStyle(
-          outsideDaysVisible: false,
-          todayDecoration: BoxDecoration(
-            color: Colors.blueGrey.shade200,
-            shape: BoxShape.circle,
-          ),
-          todayTextStyle: const TextStyle(color: Colors.black),
-          selectedDecoration: const BoxDecoration(
-            color: Colors.deepPurple,
-            shape: BoxShape.circle,
-          ),
-          selectedTextStyle: const TextStyle(color: Colors.white),
-          weekendTextStyle: const TextStyle(color: Colors.redAccent),
-        ),
+        calendarStyle: CalendarStyle(
+          outsideDaysVisible: false,
+          todayDecoration: BoxDecoration(
+            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
+            shape: BoxShape.circle,
+          ),
+          todayTextStyle: Theme.of(context).textTheme.bodyText1!,
+          selectedDecoration: BoxDecoration(
+            color: Theme.of(context).colorScheme.primary,
+            shape: BoxShape.circle,
+          ),
+          selectedTextStyle: TextStyle(
+            color: Theme.of(context).colorScheme.onPrimary),
+          weekendTextStyle: TextStyle(
+            color: Theme.of(context).colorScheme.error),
+        ),
