
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


// widgets

class HistorySheetContainerBody extends StatefulWidget {
  final String status;
  final String date;
  final String startTime;
  final String endTime;
  final String? currentLocation;
  final String endLocation;
  final String startLocation;
  final bool? isInfo;
  const HistorySheetContainerBody({
    Key? key,
    this.isInfo,
    required this.status,
    required this.date,
    required this.startTime,
    required this.endTime, required this.currentLocation, required this.endLocation, required this.startLocation,
  }) : super(key: key);

  @override
  HistorySheetContainerBodyState createState() => HistorySheetContainerBodyState();
}

class HistorySheetContainerBodyState extends State<HistorySheetContainerBody> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _jobTitleController = TextEditingController();


  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(40.4018, 44.6434),
    zoom: 15,
  );

 final  _markers = <Marker>[];
 final List<Marker> _list = const [
 Marker(markerId: MarkerId('1'),position: LatLng(40.4018, 44.6434),
 infoWindow: InfoWindow(title: 'Current Location'),
 ),
   Marker(markerId: MarkerId('2'),position: LatLng(40.4030, 44.6470),
     infoWindow: InfoWindow(title: 'Start Location'),
   ),
   Marker(markerId: MarkerId('3'),position: LatLng(40.4080, 44.6500),
     infoWindow: InfoWindow(title: 'End Location'),
   ),
 ];


  @override
  void initState() {
    super.initState();
    _markers.addAll(_list);
    _firstNameController.text = widget.status;
    _lastNameController.text = widget.startTime;
    _jobTitleController.text = widget.endTime;
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(

        padding: const EdgeInsets.only(top: 27.0 + 56.0, right: 20.0, left: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Status',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.0,
                    letterSpacing: 0.014,
                    color: Color(0xFF212121),
                  ),
                ),
                 const SizedBox(height: 3),
                 Text(widget.status,
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.w400,
                    fontSize: 14.0,
                    letterSpacing: 0.014,
                    color: Color(0xFF212121),
                  ),
                ),

              ],),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Date',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.0,
                      letterSpacing: 0.014,
                      color: Color(0xFF212121),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(widget.date,
                    style:const TextStyle(
                      fontFamily: 'Roboto',
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.w400,
                      fontSize: 14.0,
                      letterSpacing: 0.014,
                      color: Color(0xFF212121),
                    ),
                  ),

                ],),
            ],),
            // first name input
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Start Time',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.0,
                        letterSpacing: 0.014,
                        color: Color(0xFF212121),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(widget.startTime,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.w400,
                        fontSize: 14.0,
                        letterSpacing: 0.014,
                        color: Color(0xFF212121),
                      ),
                    ),

                  ],),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('End Time',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.0,
                        letterSpacing: 0.014,
                        color: Color(0xFF212121),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(widget.endTime,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.w400,
                        fontSize: 14.0,
                        letterSpacing: 0.014,
                        color: Color(0xFF212121),
                      ),
                    ),

                  ],),
              ],),
            // last name input
          const  SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  const  Text('Start Time',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.0,
                        letterSpacing: 0.014,
                        color: Color(0xFF212121),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(widget.startTime,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.w400,
                        fontSize: 14.0,
                        letterSpacing: 0.014,
                        color: Color(0xFF212121),
                      ),
                    ),

                  ],),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   const Text('End Time',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.0,
                        letterSpacing: 0.014,
                        color: Color(0xFF212121),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(widget.endTime,
                      style:const TextStyle(
                        fontFamily: 'Roboto',
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.w400,
                        fontSize: 14.0,
                        letterSpacing: 0.014,
                        color: Color(0xFF212121),
                      ),
                    ),

                  ],),
              ],),
            const SizedBox(height: 15),
            const Divider(
              thickness: 1.0,
              color: Color(0xFFEAEDF0),
            ),


            const  Text('Current Location',
              style: TextStyle(
                fontFamily: 'Roboto',
                decoration: TextDecoration.none,
                fontWeight: FontWeight.w600,
                fontSize: 14.0,
                letterSpacing: 0.014,
                color: Color(0xFF212121),
              ),
            ),
            if(widget.currentLocation !=null)
              SizedBox(
                height: 400,
                width: MediaQuery.of(context).size.width,
                child: GoogleMap(
                  mapType: MapType.normal,
                  markers: Set<Marker>.of(_markers),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  myLocationEnabled: true,
                  initialCameraPosition: _kGooglePlex,
                  zoomControlsEnabled: false,
                  zoomGesturesEnabled: true,
                  mapToolbarEnabled:true,
                  myLocationButtonEnabled: false,


                ),),

            const SizedBox(height: 10
            ),const SizedBox(height: 30,)
          ],
        ),
      ),
    );
  }
}