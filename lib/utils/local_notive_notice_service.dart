// import 'package:flutter/cupertino.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest.dart' as tzData;
//
// final _localNotificationsPlugin = FlutterLocalNotificationsPlugin();
//
// class LocalNoticeService {
//   Future<void> setup() async {
//     // #1
//     const androidSetting = AndroidInitializationSettings('@mipmap/ic_launcher');
//     const iosSetting = IOSInitializationSettings();
//
//     // #2
//     const initSettings =
//     InitializationSettings(android: androidSetting, iOS: iosSetting);
//
//     // #3
//     await _localNotificationsPlugin.initialize(initSettings).then((_) {
//       debugPrint('setupPlugin: setup success');
//     }).catchError((Object error) {
//       debugPrint('Error: $error');
//     });
//   }
//
//
// }