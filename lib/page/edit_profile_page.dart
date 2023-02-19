// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import 'package:work_timing/services/blocs/user/user_event.dart';
// import 'package:work_timing/services/blocs/user/user_state.dart';
//
// import '../services/blocs/user/user_bloc.dart';
// import '../services/data_provider/user_data_provider.dart';
// import '../services/models/user.dart';
//
// class EditUserPage extends StatelessWidget {
//   const EditUserPage({super.key,required User initialTodo});
//
//   static Route<void> route({required User initialTodo,required BuildContext ctx}) {
//     return MaterialPageRoute(
//       fullscreenDialog: true,
//       builder: (_) =>  EditUserPage(initialTodo: initialTodo,),
//
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<EditTodoBloc, EditUserState>(
//       listenWhen: (previous, current) =>
//       previous.status != current.status &&
//           current.status == UserStatus.success,
//       listener: (context, state) => Navigator.of(context).pop(),
//       child: const EditTodoView(),
//     );
//
//     // return BlocBuilder<EditTodoBloc,EditUserState>(builder: (contex,state){
//     //
//     //   return const
//     //        EditTodoView();
//     // });
//   }
// }
//
// class EditTodoView extends StatelessWidget {
//   const EditTodoView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final status = context.select((EditTodoBloc bloc) => bloc.state.status);
//     final isNewTodo = context.select(
//           (EditTodoBloc bloc) => bloc.state.isNewTodo,
//     );
//     final theme = Theme.of(context);
//     final floatingActionButtonTheme = theme.floatingActionButtonTheme;
//     final fabBackgroundColor = floatingActionButtonTheme.backgroundColor ??
//         theme.colorScheme.secondary;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Davit'
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         tooltip: 'Save',
//         shape: const ContinuousRectangleBorder(
//           borderRadius: BorderRadius.all(Radius.circular(32)),
//         ),
//         backgroundColor: status.isLoadingOrSuccess
//             ? fabBackgroundColor.withOpacity(0.5)
//             : fabBackgroundColor,
//         onPressed: status.isLoadingOrSuccess
//             ? null
//             : () => context.read<EditTodoBloc>().add(const EditUserSubmitted()),
//         child: status.isLoadingOrSuccess
//             ? const CupertinoActivityIndicator()
//             : const Icon(Icons.check_rounded),
//       ),
//       body: CupertinoScrollbar(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               children: const [_TitleField(), _DescriptionField()],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _TitleField extends StatelessWidget {
//   const _TitleField();
//
//   @override
//   Widget build(BuildContext context) {
//     final state = context.watch<EditTodoBloc>().state;
//     final hintText = state.initialTodo?.fullName ?? '';
//
//     return TextFormField(
//       key: const Key('editTodoView_title_textFormField'),
//       initialValue: state.fullName,
//       decoration: InputDecoration(
//         enabled: !state.status.isLoadingOrSuccess,
//         labelText: "fullName",
//         hintText: hintText,
//       ),
//       maxLength: 50,
//       inputFormatters: [
//         LengthLimitingTextInputFormatter(50),
//         FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]')),
//       ],
//       onChanged: (value) {
//        // context.read<EditTodoBloc>().add(EditTodoTitleChanged(value));
//       },
//     );
//   }
// }
//
// class _DescriptionField extends StatelessWidget {
//   const _DescriptionField();
//
//   @override
//   Widget build(BuildContext context) {
//
//     final state = context.watch<EditTodoBloc>().state;
//     final hintText = state.initialTodo?.email ?? '';
//
//     return TextFormField(
//       key: const Key('editTodoView_description_textFormField'),
//       initialValue: state.email,
//       decoration: InputDecoration(
//         enabled: !state.status.isLoadingOrSuccess,
//         labelText: "Edit User",
//         hintText: hintText,
//       ),
//       maxLength: 300,
//       maxLines: 7,
//       inputFormatters: [
//         LengthLimitingTextInputFormatter(300),
//       ],
//       onChanged: (value) {
//         //context.read<EditTodoBloc>().add(EditTodoDescriptionChanged(value));
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worktracker/screens/info_screen/info_screen.dart';

// Screens

import '../screens/edit_screen/edit_info_screen.dart';
import '../services/blocs/user/user_bloc.dart';
import '../services/blocs/user/user_event.dart';
import '../services/blocs/user/user_state.dart';
import '../services/models/user.dart';
import '../widget/user_info/info_section.dart';

class MyAccountScreen extends StatefulWidget {
  const MyAccountScreen({super.key});




  @override
  _MyAccountScreenState createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  late UsersBloc _myAccountBloc;

  @override
  void initState() {
    super.initState();

    _myAccountBloc = BlocProvider.of<UsersBloc>(context);
    _myAccountBloc.add(FetchMyAccount());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersBloc, EditUserState>(
        builder: (BuildContext context, EditUserState state) {
          bool isLoading = true;
          List<User> data=[] ;

          final currentState = state;

          if (currentState is MyAccountLoaded) {
            isLoading = false;
            data = state.user!;


              return MyAccount(
                data: data,
                isLoading: isLoading,
                updateMyAccountInProgress: true,
              );

          } else if (currentState is MyAccountLoading) {
            isLoading = true;
            data = [];
          }

          return MyAccount(
            myAccountBloc: _myAccountBloc,
            data: data ,
            isLoading: isLoading,
            updateMyAccountInProgress: false,
          );
        });
  }
}

class MyAccount extends StatefulWidget {
  final UsersBloc? myAccountBloc;
  final List<User> data;
  final bool isLoading;
  final bool? updateMyAccountInProgress;

  const MyAccount({
    Key? key,
     this.myAccountBloc,
    required this.data,
    required this.isLoading,
    this.updateMyAccountInProgress,
  }) : super(key: key);

  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {


  void _openEditMyInfoBottomSheetModal(
      BuildContext context, bool updateMyAccountInProgress,int index) {
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
          firstName: "${widget.data[index].firstName}",
          userName: "${widget.data[index].username}",
          password: "${widget.data[index].lastName}",
          isInfo: false,
          id: widget.data[index].id!,
          context: context,
          lastName: "${widget.data[index].lastName}",
        ),
      ),
    );
  }



  void _openInfoWidthMap(
      BuildContext context, bool updateMyAccountInProgress,index) {
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
        child: InfoScreenSheetModal(
          user: widget.data[index],
          context: context,
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView.builder(
          shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: widget.data.length,
                              itemBuilder: (BuildContext context, int index) {

                                  return InkWell(
                                    onTap: ()=>_openInfoWidthMap(context, widget.updateMyAccountInProgress!,index),
                                    child: InfoSection(
                                      fullName: widget.data == null
                                          ? ''
                                          : '${widget.data[index].firstName} ${widget.data[index].firstName}',
                                      lastName: widget.data == null
                                          ? ''
                                          : "${widget.data[index].lastName}",
                                      userName:widget.data == null
                                          ? ''
                                          : "${widget.data[index].username}",
                                       role: widget.data == null
                                           ? ''
                                           : "${widget.data[index].role}",
                                      isLoading: widget.isLoading,

                                      onEdit: () => _openEditMyInfoBottomSheetModal(
                                          context,
                                          widget.updateMyAccountInProgress!,index),

                                    ),
                                  );
                                }




                            ),
      ),
    );

  }
}