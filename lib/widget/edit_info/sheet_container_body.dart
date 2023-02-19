
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:worktracker/services/models/user.dart';


// widgets

class SheetContainerBody extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String userName;
  final String password;
  final Function? pushEditedFirstName;
  final Function? pushEditedLastName;
  final Function? pushEditedJobTitle;
  final bool? isInfo;
  final User? users;
  const SheetContainerBody({
    Key? key,
    this.isInfo,
     this.users,
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.password,
     this.pushEditedFirstName,
     this.pushEditedLastName,
     this.pushEditedJobTitle,
  }) : super(key: key);

  @override
  _SheetContainerBodyState createState() => _SheetContainerBodyState();
}

class _SheetContainerBodyState extends State<SheetContainerBody> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _jobTitleController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  FocusNode _nameFocusNode =FocusNode();
  FocusNode _lastNameFocusNode =FocusNode();
  FocusNode _jobTitleFocusNode =FocusNode();
  FocusNode _passwordFocuseNode =FocusNode();

  Completer<GoogleMapController> _controller = Completer();
  Location _location = Location();
  bool _nameFocused = false;
  bool _lastNameFocused = false;
  bool _jobTitleFocused = false;
  bool _passwrodFocused = false;
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
    _nameFocusNode = FocusNode();
    _lastNameFocusNode = FocusNode();
    _jobTitleFocusNode = FocusNode();
    _nameFocusNode.addListener(_onNameFocusChange);
    _lastNameFocusNode.addListener(_onLastNameFocusChange);
    _jobTitleFocusNode.addListener(_onJobTitleFocusChange);
   _passwordController.addListener(_onPasswordFocuseChange);
    _firstNameController.text = widget.firstName;
    _lastNameController.text = widget.userName;
    _jobTitleController.text = widget.password;
  }

  void _onNameFocusChange() {
    setState(() {
      _nameFocused = _nameFocusNode.hasFocus ? true : false;
    });
  }

  void _onLastNameFocusChange() {
    setState(() {
      _lastNameFocused = _lastNameFocusNode.hasFocus ? true : false;
    });
  }

  void _onJobTitleFocusChange() {
    setState(() {
      _jobTitleFocused = _jobTitleFocusNode.hasFocus ? true : false;
    });
  }
  void _onPasswordFocuseChange() {
    setState(() {
      _passwrodFocused = _passwordFocuseNode.hasFocus ? true : false;
    });
  }
  void _onFirstNameTextChange(name) {
    if (_firstNameController.text != '') {
      widget.pushEditedFirstName!(name);
    }
  }

  void _onLastNameTextChange(lastName) {
    if (_lastNameController.text != '') {
      widget.pushEditedLastName!(lastName);
    }
  }

  void _onJobTitleTextChange(jobTitle) {
    if (_jobTitleController.text != '') {
      widget.pushEditedJobTitle!(jobTitle);
    }
  }
  void _onPasswordChange(password) {

      widget.pushEditedJobTitle!(password);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 27.0 + 56.0, right: 20.0, left: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if(widget.isInfo == false)
              SizedBox(
                height: 300,
                child: GoogleMap(
                  mapType: MapType.normal,
                  markers: Set<Marker>.of(_markers),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  myLocationEnabled: true,
                  initialCameraPosition: _kGooglePlex,
                  zoomControlsEnabled: false,
                  zoomGesturesEnabled: false,
                  mapToolbarEnabled:true,
                  myLocationButtonEnabled: false,


                ),),
            const SizedBox(height: 15),
            const Divider(
              thickness: 1.0,
              color: Color(0xFFEAEDF0),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                const Text('First name',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.0,
                    letterSpacing: 0.014,
                    color: Color(0xFF212121),
                  ),
                ),
                Container(
                  height: 56.0,
                  margin: const EdgeInsets.only(top: 9.0),
                  padding: const EdgeInsets.only(top: 12.0,left: 12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _nameFocused ? const Color(0xFF569AFF) : const Color(0xFFCFD8DC),
                      width: 1.0,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                    color: Colors.white,
                  ),
                  child: TextField(
                    readOnly: widget.isInfo ==true  ?  false:true,
                    controller: _firstNameController..value = _firstNameController.value,
                    focusNode: _nameFocusNode,
                    enabled:  widget.isInfo ==true  ?  true:false,
                    onChanged: (name) => _onFirstNameTextChange(name),
                    textCapitalization: TextCapitalization.sentences,
                    inputFormatters: [LengthLimitingTextInputFormatter(30)],
                    style: const TextStyle(
                      color: Color(0xFF212121),
                      fontSize: 16.0,
                      decoration: TextDecoration.none,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Enter your first name',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(style: BorderStyle.none),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(style: BorderStyle.none),
                      ),
                    ),
                  ),
                ),

                // last name input
                Container(
                  margin: const EdgeInsets.only(top: 27.0),
                  child: const Text('Last name',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.0,
                      letterSpacing: 0.014,
                      color: Color(0xFF212121),
                    ),
                  ),
                ),
                Container(
                  height: 56.0,
                  margin: const EdgeInsets.only(top: 9.0, bottom: 20.0),
                  padding: const EdgeInsets.only(top: 12.0,left: 12.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _lastNameFocused ? const Color(0xFF569AFF) : const Color(0xFFCFD8DC),
                      width: 1.0,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                    color: Colors.white,
                  ),
                  child: TextField(
                    controller: _lastNameController..value = _lastNameController.value,
                    focusNode: _lastNameFocusNode,
                    readOnly: widget.isInfo ==true  ?  false:true,
                    enabled: widget.isInfo ==true  ?  true:false,
                    onChanged: (lastName) => _onLastNameTextChange(lastName),
                    textCapitalization: TextCapitalization.sentences,
                    inputFormatters: [LengthLimitingTextInputFormatter(30)],
                    style: const TextStyle(
                      color: Color(0xFF212121),
                      fontSize: 16,
                      decoration: TextDecoration.none,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Enter your last name',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          style: BorderStyle.none,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          style: BorderStyle.none,
                        ),
                      ),
                    ),
                  ),
                ),
                // user name input
                const Text(
                  'User Name',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.0,
                    letterSpacing: 0.014,
                    color: Color(0xFF212121),
                  ),
                ),
                Container(
                  height: 56.0,
                  margin: const EdgeInsets.only(top: 9.0),
                  padding: const EdgeInsets.only(top: 12.0,left: 12.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _jobTitleFocused ? const Color(0xFF569AFF) : const Color(0xFFCFD8DC),
                      width: 1.0,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                    color: Colors.white,
                  ),
                  child: TextField(
                    readOnly: widget.isInfo ==true  ?  false:true,
                    enabled: widget.isInfo ==true  ?  true:false,
                    controller: _jobTitleController..value = _jobTitleController.value,
                    focusNode: _jobTitleFocusNode,
                    onChanged: (jobTitle) => _onJobTitleTextChange(jobTitle),
                    inputFormatters: [LengthLimitingTextInputFormatter(30)],
                    style: const TextStyle(
                      color: Color(0xFF212121),
                      fontSize: 16.0,
                      decoration: TextDecoration.none,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Enter your user name',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(style: BorderStyle.none),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(style: BorderStyle.none),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin:const  EdgeInsets.only(top: 20),
                  child: const Text(
                    'Password',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.0,
                      letterSpacing: 0.014,
                      color: Color(0xFF212121),
                    ),
                  ),
                ),
                Container(
                  height: 56.0,
                  margin: const EdgeInsets.only(top: 9.0),
                  padding: const EdgeInsets.only(top: 12.0,left: 12.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _jobTitleFocused ? const Color(0xFF569AFF) : const Color(0xFFCFD8DC),
                      width: 1.0,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                    color: Colors.white,
                  ),
                  child: TextField(
                    readOnly: widget.isInfo ==true  ?  false:true,
                    enabled: widget.isInfo ==true  ?  true:false,
                    controller: _passwordController..value = _passwordController.value,
                    focusNode: _jobTitleFocusNode,
                    onChanged: (password) => _onPasswordChange(password),
                    inputFormatters: [LengthLimitingTextInputFormatter(30)],
                    style: const TextStyle(
                      color: Color(0xFF212121),
                      fontSize: 16.0,
                      decoration: TextDecoration.none,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Edit your password',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(style: BorderStyle.none),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(style: BorderStyle.none),
                      ),
                    ),
                  ),
                ),
            ],),
              ),
            ),
            // first name input



       const     SizedBox(height: 30),

          ],
        ),
      ),
    );
  }
}