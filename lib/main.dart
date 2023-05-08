



import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:worktracker/base_data/base_api.dart';
import 'screens/home_screen.dart';
import 'screens/home_screen_form/user_form.dart';
import 'services/blocs/login/login_bloc.dart';
import 'services/blocs/register/register_bloc.dart';
import 'services/blocs/user/user_bloc.dart';
import 'services/blocs/user/user_state.dart';
import 'services/data_provider/user_data_provider.dart';
import 'services/models/user_actions.dart';
import 'services/data_provider/session_data_providers.dart';
bool isAdmin = false;
const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
    'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
void startCallback() {
  // The setTaskHandler function must be called to handle the task in the background.
  FlutterForegroundTask.setTaskHandler(MyTaskHandler());
}

class MyTaskHandler extends TaskHandler {
  //UserActionsProvider? _userActionsProvider;
  final sessionDataProvider = SessionDataProvider();
  SendPort? _sendPort;
  int _eventCount = 0;
  Future<void> updateLocation(UserLocation location) async{
    var token = await sessionDataProvider.readsAccessToken();
    final userdataProvider = UserDataProvider();

    Map userData = {"location": {
    "lat":"${location.lat}",
    "lng":"${location.lng}"
    }};

    try {
      var response = await http.post(
        Uri.parse(Api.updateLocation),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':'Bearer $token'
        },
        body: json.encode(userData),
      );
      if (response.statusCode == 200) {

   print('Lat :${userData['location']['lat']} \n Lng :${userData['location']['lng']}');


      } else if (response.statusCode == 401) {
        bool isTrue = await userdataProvider.refresh();

        if (isTrue) {
          return await updateLocation(location); // Call saveFavorite recursively after refreshing token
        } else {
          debugPrint("false");
        }
      } else {
        debugPrint("failed");

      }
    } catch (e) {
      debugPrint("$e");
    }

  }
  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
    _sendPort = sendPort;

    // You can use the getData function to get the stored data.
    final customData =
    await FlutterForegroundTask.getData<String>(key: 'customData');
    debugPrint('customData: $customData');
  }

  @override
  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {
    try {
      // Get the user's current position
       await Geolocator.getCurrentPosition(    desiredAccuracy: LocationAccuracy.high,).then((value) => updateLocation(UserLocation(
         lng: value.longitude.toString(),
         lat: value.latitude.toString(),
       )));

      // Convert the DateTime object to a Map
      final timestampMap = {
        'year': timestamp.year,
        'month': timestamp.month,
        'day': timestamp.day,
        'hour': timestamp.hour,
        'minute': timestamp.minute,
        'second': _eventCount,
      };

      // Update the foreground task notification
      await FlutterForegroundTask.updateService(
        notificationTitle: 'FirstTaskHandler',
        notificationText: '$_eventCount',
      );

      // Update the user's location
      

      // Send data to the main isolate
      sendPort?.send(_eventCount);
       _eventCount++;
    } catch (e) {
      print('Error while updating location: $e');
    }

    if (kDebugMode) {
      print('cicik');
    }
  }




  @override
  Future<void> onDestroy(DateTime timestamp, SendPort? sendPort) async {
    // You can use the clearAllData function to clear all the stored data.
    await FlutterForegroundTask.clearAllData();
  }

  @override
  void onButtonPressed(String id) {
    // Called when the notification button on the Android platform is pressed.
    debugPrint('onButtonPressed >> $id');
  }

  @override
  void onNotificationPressed() {
    // Called when the notification itself on the Android platform is pressed.
    //
    // "android.permission.SYSTEM_ALERT_WINDOW" permission must be granted for
    // this function to be called.

    // Note that the app will only route to "/resume-route" when it is exited so
    // it will usually be necessary to send a message through the send port to
    // signal it to restore state when the app is already started.
    FlutterForegroundTask.launchApp("/userscreen");
    _sendPort?.send('onNotificationPressed');
  }
}
@pragma('vm:entry-point')
void updateCallback() {
  FlutterForegroundTask.setTaskHandler(SecondTaskHandler());
}

class SecondTaskHandler extends TaskHandler {
  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {

  }

  @override
  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {
    FlutterForegroundTask.updateService(
      notificationTitle: 'SecondTaskHandler',
      notificationText: timestamp.toString(),
    );

    // Send data to the main isolate.
    sendPort?.send(timestamp);
    Position position = await Geolocator.getCurrentPosition();
    debugPrint("2Task ${position.longitude}\n ${position.latitude}");
  }

  @override
  Future<void> onDestroy(DateTime timestamp, SendPort? sendPort) async {

  }
}
void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);


  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);


  //await LocalNoticeService().setup();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    debugPrint('App was detached!');
  });
initialization();
  runApp(const MyApp());
}
Future initialization() async {

  await Future.delayed(const Duration(seconds: 3));
  FlutterNativeSplash.remove();
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  String? initialMessage;
  //final UserActionsProvider _userActionsProvider = UserActionsProvider();

  late Timer timer;
  //late Position _currentPosition;
  //bool _resolved = false;
  bool serviceEnabled = false;
  ReceivePort? _receivePort;

  void _initForegroundTask() {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'notification_channel_id',
        channelName: 'Foreground Notification',
        channelDescription:
        'This notification appears when the foreground service is running.',
        channelImportance: NotificationChannelImportance.HIGH,
        priority: NotificationPriority.HIGH,
        iconData: const NotificationIconData(
          resType: ResourceType.mipmap,
          resPrefix: ResourcePrefix.ic,
          name: 'launcher',
          backgroundColor: Colors.orange,
        ),
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: true,
      ),
      foregroundTaskOptions: const ForegroundTaskOptions(
        interval: 60000,
        isOnceEvent: false,
        autoRunOnBoot: true,
        allowWakeLock: true,
        allowWifiLock: true,
      ),

    );
  }

  Future<bool> startForegroundTask() async {
    // "android.permission.SYSTEM_ALERT_WINDOW" permission must be granted for
    // onNotificationPressed function to be called.
    //
    // When the notification is pressed while permission is denied,
    // the onNotificationPressed function is not called and the app opens.
    //
    // If you do not use the onNotificationPressed or launchApp function,
    // you do not need to write this code.
    if (!await FlutterForegroundTask.canDrawOverlays) {
      final isGranted =
      await FlutterForegroundTask.openSystemAlertWindowSettings();
      if (!isGranted) {
        debugPrint('SYSTEM_ALERT_WINDOW permission denied!');
        return false;
      }
    }

    // You can save data using the saveData function.
    await FlutterForegroundTask.saveData(key: 'customData', value: '');

    bool reqResult;
    if (await FlutterForegroundTask.isRunningService) {
      reqResult = await FlutterForegroundTask.restartService();
    } else {
      reqResult = await FlutterForegroundTask.startService(
        notificationTitle: 'Work is running',
        notificationText: 'Tap to return to the app',
        callback: startCallback,
      );
    }

    ReceivePort? receivePort;
    if (reqResult) {
      receivePort = await FlutterForegroundTask.receivePort;
    }

    return _registerReceivePort(receivePort);
  }

  Future<bool> stopForegroundTask() async {
    return await FlutterForegroundTask.stopService();
  }

  bool _registerReceivePort(ReceivePort? receivePort) {
    _closeReceivePort();

    if (receivePort != null) {
      _receivePort = receivePort;
      _receivePort?.listen((message) async {
        if (message is int) {
          debugPrint('eventCount: $message');
        } else if (message is String) {
          if (message == 'onNotificationPressed') {

            Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (_)=>const UserScreen()));
          }
        } else if (message is DateTime) {
          debugPrint('timestamp: ${message.toString()}');
        }
      });

      return true;
    }

    return false;
  }

  void _closeReceivePort() {
    _receivePort?.close();
    _receivePort = null;
  }

  T? _ambiguate<T>(T? value) => value;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _handleLocationPermission();
    _initForegroundTask();
    _ambiguate(WidgetsBinding.instance)?.addPostFrameCallback((_) async {
      // You can get the previous ReceivePort without restarting the service.
      if (await FlutterForegroundTask.isRunningService) {
        final newReceivePort = await FlutterForegroundTask.receivePort;
        _registerReceivePort(newReceivePort);
      }
    });
  }


  Future<bool> _handleLocationPermission() async {

    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if(context.mounted){


        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'Location services are disabled. Please enable the services')));
      }

      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if(context.mounted){
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Location permissions are denied')));
        }

        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      if(context.mounted){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'Location permissions are permanently denied, we cannot request permissions.')));
      }

      return false;
    }
    return true;
  }



  //Locale? _locale;
  @override
  Widget build(BuildContext context) {
    final user = UserDataProvider();
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginCubit>(create: (_) => LoginCubit(user)),
        BlocProvider<RegisterCubit>(create: (_) => RegisterCubit(user)),
       BlocProvider<UsersBloc>(create: (_) => UsersBloc(MyAccountInitial())),
      ],
      child:const MaterialApp(
    debugShowCheckedModeBanner: false,


    home:  HomeScreen(),


    ));
  }
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _closeReceivePort();
    super.dispose();
  }
}

