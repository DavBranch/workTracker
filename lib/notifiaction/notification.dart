// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:geolocator/geolocator.dart';
//
// class MyNotification {
//
//   FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
//
//   Future showNotificationWithoutSound(Position position) async {
//     print(position.toString());
//     var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
//         '1', 'location-bg',
//         playSound: false, importance: Importance.max, priority: Priority.high);
//     var iOSPlatformChannelSpecifics =
//     const DarwinNotificationDetails(presentSound: false);
//     var platformChannelSpecifics = NotificationDetails(
//
//         android: androidPlatformChannelSpecifics,iOS: iOSPlatformChannelSpecifics);
//     await flutterLocalNotificationsPlugin?.show(
//       0,
//       'Location fetched',
//       position.toString(),
//       platformChannelSpecifics,
//       payload: '',
//     );
//   }
//
//   MyNotification() {
//     var initializationSettingsAndroid =  AndroidInitializationSettings('@mipmap/ic_launcher');
//     //var initializationSettingsIOS =  IOSInitializationSettings();
//     var initializationSettings =  InitializationSettings(
//         android: initializationSettingsAndroid);
//     flutterLocalNotificationsPlugin =  FlutterLocalNotificationsPlugin();
//     flutterLocalNotificationsPlugin?.initialize(initializationSettings);
//   }
// }