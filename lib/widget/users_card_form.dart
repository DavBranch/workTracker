
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worktracker/screens/info_screen/info_screen.dart';
import 'package:worktracker/services/data_provider/user_data_provider.dart';
import 'package:worktracker/utils/user_preferences.dart';
import 'package:worktracker/widget/user_info/info_section.dart';

import '../page/edit_profile_page.dart';
import '../screens/edit_screen/edit_info_screen.dart';
import '../services/blocs/user/user_bloc.dart';
import '../services/blocs/user/user_event.dart';
import '../services/blocs/user/user_state.dart';
import '../services/models/user.dart';



class DashboardData extends StatefulWidget {


  const DashboardData({Key? key,}) : super(key: key);

  @override
  State<DashboardData> createState() => _DashboardDataState();
}

class _DashboardDataState extends State<DashboardData> {
  final UserDataProvider _userDataProvider = UserDataProvider();
  Future<List<User>>? _users;
@override
  void initState() {

  _users =  _userDataProvider.getUser();
    super.initState();
  }


  void _openInfoWidthMap(
      BuildContext context,User user ,bool isinfo) {
    FocusScope.of(context).requestFocus(FocusNode());
    showModalBottomSheet(
      isDismissible: true,
      barrierColor: Color(0xFFF5F6F6).withOpacity(0.7),
      elevation: 3,
      useRootNavigator: true,
      isScrollControlled: true,
      enableDrag: false,
      context: context,
      builder: (_) => BlocProvider.value(
        value: BlocProvider.of<UsersBloc>(context),
        child: InfoScreenSheetModal(
          id: user?.id,
          user: user,
          context: context,
        ),
      ),
    );
  }

void _onDelete({required List<User> users,required int index,required int userId})async{
    users.removeAt(index);
 bool isDelete = await _userDataProvider.deleteUser(userId);
  if(isDelete)ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text("User Deleted!"),
  ));;
 setState((){});
}
  void _openEditMyInfoBottomSheetModal(
      BuildContext context,{required User user}) {
    FocusScope.of(context).requestFocus(FocusNode());
    showModalBottomSheet(
      isDismissible: true,
      barrierColor: Color(0xFFF5F6F6).withOpacity(0.7),
      elevation: 3,
      useRootNavigator: true,
      isScrollControlled: true,
      enableDrag: true,
      context: context,
      builder: (newContext) => BlocProvider.value(
        value: BlocProvider.of<UsersBloc>(context),
        child: EditMyInfoBottomSheetModal(
          firstName: user.firstName!,
          lastName: user.lastName!,
          userName: user.username!,
          password: user.role!,
          context: context,
          isInfo: true,
          id: user.id!,
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return  Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        FutureBuilder(
    future: _users,
    builder: (context,snapshot) {
            switch(snapshot.connectionState){
              case ConnectionState.waiting:
              return const Padding(
                padding:  EdgeInsets.only(top: 50),
                child:  Center(child: CircularProgressIndicator(),),
              );
                case ConnectionState.done:
              default:
                if(snapshot.hasError){
                  return Text( "${snapshot.hasError}");
                }else if(snapshot.hasData){
                  return Expanded(
                    child: RefreshIndicator(
                      onRefresh: _pullRefresh,
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data?.length,
                          itemBuilder: (context, index) {
                            User user = snapshot.data![index];

                            return GestureDetector(
                              onTap: ()=>_openInfoWidthMap(context,user,true),

                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InfoSection(
                                  onDelete:()=> _onDelete( userId: user.id!,users:snapshot.data!,index:index,),
                                  fullName: '${user.firstName}',
                                  lastName: "${user.lastName}",
                                  userName:"${user.username}",
                                  role:"${user.role}",
                                  isLoading: true,

                                  onEdit:()=> _openEditMyInfoBottomSheetModal(context,user: user),

                                ),
                              ),
                            );

                          }),
                    ),
                  );
                }else{
                  return const Text('No data');
                }
            }
            }
          ),

      ],
    );
  }
  Future<void> _pullRefresh() async {
    List<User> freshNumbers = await _userDataProvider.getUser();
    setState(() {
      _users = Future.value(freshNumbers);
    });
  }
}
