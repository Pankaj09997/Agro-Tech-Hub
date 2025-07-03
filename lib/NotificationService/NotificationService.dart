import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  // Create an instance of FlutterLocalNotificationsPlugin
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // This method will handle notification responses
  static Future<void> onDidReceiveNotification(
      NotificationResponse notificationResponse) async {
    // Handle notification response here
    print("Notification tapped: ${notificationResponse.payload}");
  }

  // Initialize the notification plugin
  static Future<void> init() async {
    // Android initialization settings
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("@mipmap/ic_launcher");

    // iOS initialization settings
    const DarwinInitializationSettings darwinInitializationSettings =
        DarwinInitializationSettings();

    // Combine both Android and iOS settings
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: darwinInitializationSettings,
    );

    // Initialize FlutterLocalNotificationsPlugin instance
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          onDidReceiveNotification, // Correct function assignment
      onDidReceiveBackgroundNotificationResponse:
          onDidReceiveNotification, // Correct function assignment
    );
    //request permission classes for android
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static Future<void> showInstantNotification(String title, String body) async {
//define notification details
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: AndroidNotificationDetails("channel_Id", "channel_Name",
            importance: Importance.high, priority: Priority.high),
        iOS: DarwinNotificationDetails());
    await flutterLocalNotificationsPlugin.show(
        0, title, body, platformChannelSpecifics);
  }

//   static Future<void> scheduleNotification(
//       String title, String body, DateTime scheduledDate) async {
// //define notification details
//     const NotificationDetails platformChannelSpecifics = NotificationDetails(
//         android: AndroidNotificationDetails("channel_Id", "channel_Name",
//             importance: Importance.high, priority: Priority.high),
//         iOS: DarwinNotificationDetails());
//     await flutterLocalNotificationsPlugin.zonedSchedule(0, title, body,
//         tz.TZDateTime.from(scheduledDate, tz.local), platformChannelSpecifics,
//         uiLocalNotificationDateInterpretation:
//             UILocalNotificationDateInterpretation.absoluteTime,
//         androidScheduleMode: androidScheduleMode,
//         matchDateTimeComponents: DateTimeComponents.dateAndTime
//         );
//   }
}
