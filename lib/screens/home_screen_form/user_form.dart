import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:worktracker/screens/Login/login_screen.dart';
import 'package:worktracker/services/data_provider/session_data_providers.dart';
import 'package:worktracker/services/data_provider/users_info_api.dart';
import 'package:worktracker/services/models/user_actions.dart';

import '../../main.dart';

class UserScreen extends StatefulWidget {
  const  UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final UserActionsProvider _userActionsProvider = UserActionsProvider();
  final _isHours = true;
  final  _sessionDataProvider =  SessionDataProvider();
  bool _backgroundTaskIsOff = false;
  late  String stopedTimerData ='';
   bool serviceEnabled = false;
  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
    //onChange: (value) => print('onChange $value'),
    onStopped: () {
    },
    onEnded: () {
    },
  );
  Position? _currentPosition;

  // Future<void> _getCurrentPosition()async {
  //   final hasPermission = await _handleLocationPermission();
  //
  //   if (!hasPermission) return;
  //   await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
  //       .then((Position position) {
  //     setState(() => _currentPosition = position);
  //   }).catchError((e) {
  //     debugPrint(e);
  //   });
  // }
  Future<void> _getCurrentPosition() async {
    // Check if location permission is granted and request permission if necessary
    if (await Permission.location.request().isGranted) {
      // permission is granted, get the location
      try {
        final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
        final Position position = await geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(accuracy: LocationAccuracy.high));
        setState(() {
          _currentPosition = position;
        });
      } catch (error) {
        print(error);
      }
    } else {
      // permission is not granted, request it
      await Permission.location.request();
      // check again if permission is granted or not
      if (await Permission.location.request().isGranted) {
        // permission is granted, get the location
        try {
          final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
          final Position position = await geolocator.getCurrentPosition(locationSettings: const LocationSettings(accuracy: LocationAccuracy.high));
          setState(() {
            _currentPosition = position;
          });
        } catch (error) {
          print(error);
        }
      } else {
        // permission is denied or permanently denied, show an alert or dialog
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('Location Permission'),
            content: Text('Please enable location services all the time'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('CANCEL'),
              ),
              TextButton(
                onPressed: () => openAppSettings(),
                child: Text('SETTINGS'),
              ),
            ],
          ),
        );
      }
    }
  }

  Future<bool> _handleLocationPermission() async{

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
              'Location permissions are permanently denied, we cannot request permissions.')));}

      return false;
    }
    return true;
  }


  @override
  void initState() {
    _loadData();
    _handleLocationPermission();

    _stopWatchTimer.rawTime.listen((value) {
      if (kDebugMode) {
       // print('rawTime $value ${StopWatchTimer.getDisplayTime(value)}');
        setState(() {
          stopedTimerData = StopWatchTimer.getDisplayTime(value);

        });
      }

    }
    );
    super.initState();
  }
   _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String savedWorkTime = prefs.getString("work_time") ?? "";
    if(savedWorkTime.isNotEmpty){
      var parsedWorkTime= DateTime.parse(savedWorkTime);
      DateTime dateNow = DateTime.now();
      int difference = parsedWorkTime.difference(dateNow).inMilliseconds;

      _stopWatchTimer.setPresetTime(mSec: difference.abs());
      _stopWatchTimer.onStartTimer();
    }
   

  }
  _removeData()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("work_time");

  }
  _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("work_time", DateTime.now().toString());
  }
  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose();
  }
  @override
  Widget build(BuildContext context) {
    
    return SafeArea(child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0.0,title:const Text('Working Time'),
          actions: [
            PopupMenuButton<int>(
              onSelected: (item) => _handleClick(item),
              itemBuilder: (context) => [

                PopupMenuItem<int>(value: 2, child: GestureDetector(
                    onTap: (){
                      _sessionDataProvider.deleteAllToken();

                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                          const LoginScreen()), (Route<dynamic> route) => false);                    },
                    child: const Text('Logout'))),


              ],
            ),
          ],
        ),

        body:  Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 32,
        horizontal: 16,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _getRadialGauge(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              !_stopWatchTimer.isRunning ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue ),

                  onPressed: (){
                    _getCurrentPosition();

                   if(serviceEnabled){
                     MyAppState().startForegroundTask().then((value) => setState(() =>_backgroundTaskIsOff = value),);
                      _saveData();
                      _stopWatchTimer.onStartTimer();
                      if(_currentPosition != null && _stopWatchTimer.isRunning){
                        UserLocation  location = UserLocation(lat: _currentPosition?.latitude.toString(), lng: _currentPosition?.longitude.toString(), );
                        UserActions action = UserActions(location: location,time: stopedTimerData,type: 'start');
                          _userActionsProvider.fetchUserActions(action);

                      }
                    }
                  },
                  child: const Text(
                    'Start',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ): const SizedBox(),
              _stopWatchTimer.isRunning?   Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child:ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.lightGreen ),

                  onPressed: ()async{
                    _stopWatchTimer.onStopTimer();
                    MyAppState().stopForegroundTask().then((value) => setState(() =>_backgroundTaskIsOff = value),);
                    UserLocation  location = UserLocation(lat: _currentPosition?.latitude.toString(), lng: _currentPosition?.longitude.toString(), );
                    await  _getCurrentPosition();
                    if( !_stopWatchTimer.isRunning ){
                      _removeData();
                      UserActions action = UserActions(location: location,time: stopedTimerData,type: 'end');
                      await  _userActionsProvider.fetchUserActions(action);

                    }
                  },
                  child: const Text(
                    'Stop',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ) :const SizedBox(),

            ],
          ),
        ],
      ),
    )));
  }
  Widget _getRadialGauge() {
    return SfRadialGauge(
        axes:<RadialAxis>[RadialAxis( interval: 1, showFirstLabel: false,
          startAngle: 270, endAngle: 270, minimum: 0, maximum: 12,
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
                widget: StreamBuilder<int>(
                  stream: _stopWatchTimer.rawTime,
                  initialData: _stopWatchTimer.rawTime.value,
                  builder: (context, snap) {
                    final value = snap.data!;
                    final displayTime =
                    StopWatchTimer.getDisplayTime(value, hours: _isHours,milliSecond: false);
                    return
                      Container(
                        margin: const EdgeInsets.only(bottom: 150),
                        child: Text(
                          displayTime,
                          style: const TextStyle(
                              fontSize: 40,
                              fontFamily: 'Helvetica',
                              fontWeight: FontWeight.bold),
                        ),

                      );
                  },
                ),
                angle: 90,
                positionFactor: 0.5)
          ],


        ),
        ]
    )
    ;
  }
  void _handleClick(int item) {
    switch (item) {
      case 0:
        break;
      case 1:
        break;
      case 2:
        break;
    }
  }
}
