import 'package:flutter/material.dart';
import 'package:worktracker/screens/history/history_screen.dart';
import 'package:worktracker/screens/home_screen_form/admin_form.dart';

import '../../widget/users_card_form.dart';
import 'package:worktracker/services/data_provider/session_data_providers.dart';
import '../Login/login_screen.dart';
class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final _sessionDataProvider = SessionDataProvider();

  @override
  void initState() {

    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return SafeArea(child:
    Scaffold(
      backgroundColor:Colors.grey.shade100,
        appBar: AppBar(title: const Text('Users'),
            automaticallyImplyLeading: false,
          backgroundColor: Colors.blueAccent,
          elevation: 0.0,
          leading: null,
          actions: [
            PopupMenuButton<int>(
              onSelected: (item) => handleClick(item),
              itemBuilder: (context) => [
                PopupMenuItem<int>(value: 0, child: GestureDetector(
                    onTap: (){
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(builder: (_)=>const AdminScreen()));
                    },
                    child: const Text('Add User'))),
                PopupMenuItem<int>(value: 1, child: GestureDetector(
                    onTap: (){
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(builder: (_)=>const HistoryScreen(),));
                    },
                    child: const Text('History'))),
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


        body:const DashboardData(),


    ) ,);
  }
  void handleClick(int item) {
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

