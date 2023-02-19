import 'package:flutter/cupertino.dart';
import 'package:flutter_foreground_task/ui/with_foreground_task.dart';
import 'package:worktracker/screens/Login/login_form.dart';
import 'package:worktracker/screens/Login/login_screen.dart';
import 'package:worktracker/screens/home_screen_form/admin_form.dart';
import 'package:worktracker/screens/home_screen_form/user_form.dart';
import 'package:worktracker/screens/users/users.dart';
import 'package:worktracker/services/data_provider/session_data_providers.dart';
import 'package:worktracker/services/models/user.dart';

import '../utils/notification_service.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
SessionDataProvider _sessionDataProvider = SessionDataProvider();
String? _token;
String?  is_user;
String? isValid;
bool? isUser = false;
  @override
  void initState() {
    loginUser();

    //NotificationService.initialize(context);

    // FirebaseMessaging.instance.getInitialMessage().then((message) {
    //   if (message != null) {
    //     print('dadas');
    //     final routeFromMessage = message.data["route"];
    //
    //     Navigator.of(context).pushNamed(routeFromMessage);
    //   }
    // });
    // FirebaseMessaging.onMessage.listen((message) {
    //   if (message.notification != null) {
    //     print('madas');
    //     print(message.notification!.body);
    //     print(message.notification!.title);
    //   }
    //
    // });

    // FirebaseMessaging.onMessageOpenedApp.listen((message) {
    //   final routeFromMessage = message.data["route"];
    //
    //   Navigator.of(context).pushNamed(routeFromMessage);
    // });
    super.initState();
  }
  // void getToken() async {
  //   String? token = await messaging.getToken();
  //
  //   if (token != null && deviceId != null) {
  //     var data = {'device_id': deviceId, 'fcm_token': token};
  //     print("DATATATATAT$data");
  //     _userDataProvider.postFCMToken(data);
  //   }
  // }


Future<void> loginUser() async {
  isValid = await _sessionDataProvider.readsAccessToken();
  is_user = await _sessionDataProvider.readRole();
  if (isValid != null && is_user == "true") {
    setState(() {
      isUser = true;
    });
  } else {
    setState(() {
      isUser = isUser;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return  WithForegroundTask(child: SafeArea(child: isValid !=null  && !isUser!  ? const UsersScreen():isValid !=null  && isUser! ?const UserScreen() : const LoginScreen()));
  }
}
