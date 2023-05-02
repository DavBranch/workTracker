import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worktracker/services/blocs/user/user_bloc.dart';

// Widgets
import '../../services/blocs/user/user_state.dart';
import '../../widget/history_info/history_bar.dart';
import '../../widget/history_info/history_body.dart';


class HistoryInfoScreenSheetModal extends StatefulWidget {
  final BuildContext context;
  final String firstName;
  final String lastName;
  final String userName;
  final String password;
  final int id;
  final bool updateMyAccountInProgress;

  const HistoryInfoScreenSheetModal({
    Key? key,
    required this.id,
    required this.context,
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.password,
    required this.updateMyAccountInProgress,
  }) : super(key: key);

  @override
  HistoryInfoScreenSheetModalState createState() =>  HistoryInfoScreenSheetModalState();
}

class HistoryInfoScreenSheetModalState extends State<HistoryInfoScreenSheetModal> {
  //
  // String? _firstName;
  // String? _userName;
  // int? _id;
  // String? _password;


  @override
  Widget build(BuildContext context) {

    return BlocBuilder<UsersBloc, EditUserState>(builder: (BuildContext _, state) {
      return SizedBox(
        height: MediaQuery.of(context).size.height ,
        child: Stack(
          children: <Widget>[
            Container(
              child: state.updateMyAccountInProgress??false ? Container(
                color: Colors.white.withOpacity(0.9),
                child: const Align(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                ),
              ) : Column(
                children: [
                  Expanded(
                    child: HistorySheetContainerBody(
                      isInfo: widget.updateMyAccountInProgress,
                      status: 'ongoing',
                      startTime: '2022-12-18',
                      startLocation: 'start_location": {"lat": "56.57678765","lng": "15.161"}',
                      endTime: '2022-12-18',
                      endLocation:  'start_location": {"lat": "56.57678765","lng": "15.161"}',
                      date: '2022-12-18',
                      currentLocation:  'start_location": {"lat": "56.57678765","lng": "15.161"}',

                    ),
                  ),


                ],
              ),

            ),
            const    Padding(
              padding:  EdgeInsets.only(top: 20),
              child: HistoryInfoAppBar(
              ),
            ),
          ],
        ),
      );
    });
  }
}