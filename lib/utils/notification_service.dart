// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:rxdart/subjects.dart';
// import 'package:timezone/data/latest_all.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
//
// final BehaviorSubject<String?> selectNotificationSubject =
// BehaviorSubject<String?>();
// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     'high_importance_channel', // id
//     'High Importance Notifications', // title
//     description:
//     'This channel is used for important notifications.', // description
//     importance: Importance.high,
//     playSound: true);
//
//
// int id = 0;
// class NotificationService {
//   factory NotificationService() {
//     return _notificationService;
//   }
//   static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//   NotificationService._internal();
//
//   static const channelId = '123';
//
//   String? selectedNotificationPayload;
//   static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//     print(" --- background message received ---");
// // repeatNotification();
//     print(message.notification!.title);
//     print(message.notification!.body);
//   }
//   //NotificationService a singleton object
//   static final NotificationService _notificationService =
//   NotificationService._internal();
//
//   static AndroidNotificationDetails _androidNotificationDetails =
//   AndroidNotificationDetails(
//     'channel ID',
//     'channel name',
//     channelDescription: 'channel description',
//     icon: '@mipmap/ic_launcher',
//     playSound: true,
//     priority: Priority.high,
//     importance: Importance.high,
//   );
//  static Future<void> repeatNotification() async {
//     const AndroidNotificationDetails androidNotificationDetails =
//     AndroidNotificationDetails(
//         'repeating channel id', 'repeating channel name',
//         channelDescription: 'repeating description');
//     const NotificationDetails notificationDetails =
//     NotificationDetails(android: androidNotificationDetails);
//     await flutterLocalNotificationsPlugin.show(
//          id++,
//         'Miacreq dzer heraxosy',
//         'repeating body',
//         notificationDetails,
//         ).then((value){
//           print('davsss dzeec');
//     });
//   }
//   static void initialize(BuildContext context) async {
//     final InitializationSettings initializationSettings =
//     InitializationSettings(
//         android: AndroidInitializationSettings("@mipmap/ic_launcher"));
//
//     flutterLocalNotificationsPlugin.initialize(initializationSettings,);
//         // onSelectNotification: (String? route) async {
//         //   if (route != null) {
//         //     Map<String, dynamic> noteData = json.decode(route);
//         //     String id = noteData.values.toString();
//         //     print("Notif Dataaaaaaaaa $id");
//         //     if (route.contains('lessons')) {
//         //       Navigator.of(context).push(MaterialPageRoute(
//         //           builder: (_) => ItaliaLessonShow(
//         //             idLessons: id,
//         //           )));
//         //     } else if (route.contains('libraries')) {
//         //       Navigator.of(context)
//         //           .push(MaterialPageRoute(builder: (_) => BookInitalScreen()));
//         //     } else if (route.contains('encyclopedias')) {
//         //       Navigator.of(context).push(MaterialPageRoute(
//         //           builder: (_) => BookReadScreen(
//         //             encyId: id,
//         //           )));
//         //     } else if (route.contains('audiolibraries')) {
//         //       Navigator.of(context).push(MaterialPageRoute(
//         //           builder: (_) => AudioLibraryDataShow(
//         //             adbId: id,
//         //           )));
//         //     } else {
//         //       Navigator.of(context)
//         //           .push(MaterialPageRoute(builder: (_) => Dialect()));
//         //     }
//         //
//         //     Navigator.of(context).pushNamed(route);
//         //   }
//         // });
//   //
//   //   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   //   tz.initializeTimeZones();
//   //
//   //   await flutterLocalNotificationsPlugin.zonedSchedule(
//   //       0,
//   //       'scheduled title',
//   //       'scheduled body',
//   //       tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
//   //       const NotificationDetails(
//   //           android: AndroidNotificationDetails(
//   //               'your channel id', 'your channel name',
//   //               channelDescription: 'your channel description')),
//   //       androidAllowWhileIdle: true,
//   //       uiLocalNotificationDateInterpretation:
//   //       UILocalNotificationDateInterpretation.absoluteTime);
//   //
//   //
//   // }
//
//   // static void display(RemoteMessage message) async {
//   //   try {
//   //     final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
//   //
//   //     final NotificationDetails notificationDetails = NotificationDetails(
//   //         android: AndroidNotificationDetails(
//   //           "work",
//   //           "work",
//   //           channelDescription: "this is our channel",
//   //           importance: Importance.max,
//   //           priority: Priority.high
//   //         ),
//   //
//   //     );
//   //
//   //     await flutterLocalNotificationsPlugin.show(
//   //       id,
//   //       message.notification!.title,
//   //       message.notification!.body,
//   //       notificationDetails,
//   //       payload: message.data['route'],
//   //     );
//   //   } on Exception catch (e) {
//   //     print(e);
//   //   }
//   // }
//
//  static Future<void> showNotificationWithCustomSubText() async {
//     const AndroidNotificationDetails androidNotificationDetails =
//     AndroidNotificationDetails(
//       'your channel id',
//       'your channel name',
//       channelDescription: 'your channel description',
//       importance: Importance.max,
//       priority: Priority.high,
//       showWhen: false,
//       subText: 'custom subtext',
//     );
//     const NotificationDetails notificationDetails =
//     NotificationDetails(android: androidNotificationDetails);
//     await flutterLocalNotificationsPlugin.show(
//         id++, 'plain title', 'plain body', notificationDetails,
//         payload: 'item x');
//   }
// }
//
// class SecondScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Center(
//         child: Text('data'),
//       ),
//     );
//   }
// }
