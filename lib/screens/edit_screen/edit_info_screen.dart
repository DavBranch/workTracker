import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Widgets
import '../../services/blocs/user/user_bloc.dart';
import '../../services/blocs/user/user_event.dart';
import '../../services/blocs/user/user_state.dart';
import '../../widget/edit_info/app_bar.dart';
import '../../widget/edit_info/sheet_container_body.dart';


class EditMyInfoBottomSheetModal extends StatefulWidget {
  final BuildContext context;
  final String firstName;
  final String lastName;
  final String userName;
  final String password;
  final bool? isInfo;
  final int id;

   const EditMyInfoBottomSheetModal({
    Key? key,
    required this.id,
    this.isInfo,
    required this.context,
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.password,
  }) : super(key: key);

  @override
  EditMyInfoBottomSheetModalState createState() =>  EditMyInfoBottomSheetModalState();
}

class EditMyInfoBottomSheetModalState extends State<EditMyInfoBottomSheetModal> {
  late UsersBloc _myAccountBloc;

  String? _firstName;
  String? _userName;
  //int? _id;
  String? _lastName;
  final updateUser = GlobalKey<ScaffoldState>();


  void _getChangedFirstname(fName) {
    setState(() => _firstName = fName);
  }

  void _getChangedLastName(lName) {
    setState(() => _userName = lName);
  }

  void _getChangedJobTitle(jTitle) {
    setState(() => _lastName = jTitle);
  }

  void _onSaveButtonPressed() {
    _myAccountBloc.add(EditMyUser(
      firstName: _firstName ?? widget.firstName,
      lastName:_lastName ?? widget.lastName,
      userName: _userName ?? widget.userName,
      id: widget.id,
      context: context,
    ));
  }

  @override
  void initState() {
    super.initState();

    _myAccountBloc = BlocProvider.of<UsersBloc>(widget.context);

  }

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<UsersBloc, EditUserState>(builder: (BuildContext _, state) {
      return Container(
        margin:const EdgeInsets.only(top: 25),
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
              ) : SheetContainerBody(
                firstName: widget.firstName,
                userName: widget.userName,
                password: widget.password,
                lastName: widget.lastName,
                isInfo: widget.isInfo,
                pushEditedFirstName: _getChangedFirstname,
                pushEditedLastName: _getChangedLastName,
                pushEditedJobTitle: _getChangedJobTitle,
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: EditMyInfoAppBar(
                isShowInfo: widget.isInfo,
                onSave: _onSaveButtonPressed,
              ),
            ),

          ],
        ),
      );
    });
  }
}