import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:worktracker/services/data_provider/user_data_provider.dart';
import 'package:worktracker/services/models/info.dart';

import '../../date_range/date_range_bottom_sheet_modal.dart';
import '../../services/blocs/user/user_bloc.dart';
import '../../services/models/user_info.dart';
import 'history_info_screen.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  int currentPage = 1;
  List<dynamic> data = [];
  bool isLoading = false;
  final DateTime now = DateTime. now();
  final DateFormat formatter = DateFormat("yyyy-MM-ddT00:00:00");
  late final String date;

  bool _hasDate = false;
  Map<String,String> _date={};
  final String _currentAddress ='';
  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    final response = await http.get(Uri.parse(
        'http://165.227.204.177/api/info?page=$currentPage')); // Replace with your API endpoint
    final  dataList = jsonDecode(response.body)['data'];


    setState(() {
      data = dataList.map((json) => Datum.fromJson(json)).toList();
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: _pullRefresh,
              child: ListView.builder(
                itemCount: data.length + 1,
                itemBuilder: (BuildContext context, int index) {

                  if (index == data.length) {
                    if (isLoading) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return Container();
                    }
                  } else {
                    var user = data[index] as Datum;

                    return Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Card(

                        child: Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                  width: 2.0, color: Colors.black),
                            ),
                            color: Colors.white,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('User: ${user.user?.username ?? 'none' }'),
                              SizedBox(height: 16),
                              Text('Date: ${DateFormat('yyyy-MM-dd').format(DateTime.parse('${user.date}'))}'),
                              SizedBox(height: 16),
                              Text('Start Location: ${user.startLocation?.lat}, ${user.startLocation?.lng}'),
                              SizedBox(height: 16),
                              Text('Current Location: ${user.currentLocation?.lat}, ${user.currentLocation?.lng}'),
                              SizedBox(height: 16),
                              Text('End Location: ${user.endLocation?.lat}, ${user.endLocation?.lat}'),
                              SizedBox(height: 16),
                              Text('Duration: ${user.duration}'),
                              SizedBox(height: 16),
                              Text('Times:'),
                              if(user.times != null) for (var time in user!.times!)
                                Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Start: ${time.start}'),
                                      SizedBox(height: 8),
                                      Text('End: ${time.end}'),
                                      SizedBox(height: 16),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                    return  GestureDetector(
                     // onTap: ()=>_openInfoWidthMap(context,user!.user as UserInfo,true),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(
                            10, 10, 10, 0),

                      child: Column(
                        children: [
                          Card(
                            elevation: 0.0,
                            child: Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                      width: 2.0, color: Colors.black),
                                ),
                                color: Colors.white,
                              ),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .start,
                                    children: <Widget>[
                                      Expanded(child:user!=null? Text('Username : ${user.user?.username ?? '' } \n\nFull Name: ${user.user?.firstName ?? ''} ${user.user?.lastName ?? ''}'): const Text('')),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: <Widget>[
                                      Expanded(child: Text('Status : ${user.status ?? ''}')),
                                      const SizedBox(width: 10),
                                      Expanded(child:Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Date : ${DateFormat('yyyy-MM-dd').format(user.date!)}'),
                                          Text('Start Location : $_currentAddress'),
                                        ],
                                      ),),

                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  // Row(
                                  //   children: <Widget>[
                                  //     Expanded(child: ),
                                  //   ],
                                  // )
                                  ListView.builder(
                                      itemCount: 12,
                                      itemBuilder: (builder,index){

                                    return ListTile(title:Text('s'),);
                                  })
                                ],


                              ),
                            ),
                          ),
                        ],
                      ),
                      ));
                  }
                },
              ),
            ),
          ),
          Container(
            height: 50.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: currentPage == 1
                      ? null
                      : () {
                    setState(() {
                      currentPage--;
                      data = [];
                    });
                    fetchData();
                  },
                  child: Text('Previous'),
                ),
                SizedBox(
                  width: 10.0,
                ),
                ElevatedButton(
                  onPressed: data.isEmpty
                      ? null
                      : () {
                    setState(() {
                      currentPage++;
                      data = [];
                    });
                    fetchData();
                  },
                  child: Text('Next'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void handleClick(int item) {
    switch (item){
      case 0:
        _onDateRangeAdd();
        break;
    }
  }
  Future<void> _pullRefresh() async {
    //final DateTime now = DateTime. now();
    //final DateFormat formatter = DateFormat('yyyy-MM-dd');
    //final String newDate = formatter. format(now);
    // List<InfoUser> freshNumbers = await _userDataProvider.getUserInfo(firstCall: 'https://phplaravel-885408-3069483.cloudwaysapps.com/api/info?date=');
    // setState(() {
    //   _futureUsers = Future.value(freshNumbers);
    // });
  }
  bool _onDateRangeAdd(){

    showModalBottomSheet(
        isDismissible: true,
        barrierColor: const Color(0xFFF5F6F6).withOpacity(0.7),
        elevation: 3,
        useRootNavigator: true,
        isScrollControlled: true,
        context: context,
        builder: (_)=>DateRangeBottomSheetModal( ctx: context,dateRangePost:(hasData,date)=>setState((){
          _hasDate = hasData;
          if(hasData)_date=date;
        }),onDateReset: (reset)=> setState((){
          _hasDate = reset;
          _date = {};
          if(!reset){

          }

        }), searchSourceType: 'project_history_date',)
    );
    return _hasDate;
  }
  void _openInfoWidthMap(
      BuildContext context,UserInfo user ,bool isinfo) {
    FocusScope.of(context).requestFocus(FocusNode());
    showModalBottomSheet(
      isDismissible: false,
      barrierColor: const Color(0xFFF5F6F6).withOpacity(0.7),
      elevation: 3,
      useRootNavigator: true,
      isScrollControlled: true,
      enableDrag: false  ,
      context: context,
      builder: (newContext) => BlocProvider.value(
        value: BlocProvider.of<UsersBloc>(context),
        child: HistoryInfoScreenSheetModal(
          firstName: user.startTime.toString(),
          lastName: user.endTime.toString(),
          userName: user.userId.toString(),
          password: user.endTime.toString(),

          context: context,
          id: user.id??0,
          updateMyAccountInProgress: false,
        ),
      ),
    );
  }
}
