import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worktracker/screens/users/users.dart';
import 'package:worktracker/services/blocs/user/user_event.dart';
import 'package:worktracker/services/blocs/user/user_state.dart';
import '../../data_provider/user_data_provider.dart';
import '../../models/user.dart';


// Modals

class UsersBloc extends Bloc<MyAccountEvent, EditUserState> {
  final UserDataProvider _myAccountRepository = UserDataProvider();

  UsersBloc(EditUserState initialState) : super(initialState);
  @override
  Stream<EditUserState> mapEventToState(MyAccountEvent event) async* {
   if(event is FetchMyAccount){
     _mapFetchMyAccountToState(event);
   }
   else if (event is EditMyUser) {
      yield* _mapEditMyAccountToState(event);
    } else if (event is EditMyAccountFailure) {
      yield* _mapEditMyAccountFailureToState(event);
    }
  }

  Stream<EditUserState> _mapFetchMyAccountToState(FetchMyAccount event) async* {
    yield MyAccountLoading();

    final  myAccountData = await _myAccountRepository.getUser() ;
    final users =myAccountData;
    if (users.isNotEmpty) {
      yield MyAccountLoaded(
      listUsers: users,
      );
    } else {
      yield const MyAccountLoaded();
    }
  }
    Stream<EditUserState> _mapEditMyAccountToState(EditMyUser event) async* {
    // yield const MyAccountLoaded();
    //   if (event.firstName != null || event.lastName != null ||
    //       event.userName != null || event.id !=null) {
    //     final currentState = state;
    //
    //     if (currentState is MyAccountLoaded) {
    //       yield currentState.copyWith(updateMyAccountInProgress: true);
    //     }
    //
    //    final User? user = await _myAccountRepository.updateUser(
    //      userName: event.userName,
    //      lastName: event.lastName,
    //      firstName: event.firstName,
    //      id: event.id,
    //    );
    //
    //     // if (myAccountData['errors'] == null) {
    //     //   // final User myAccountData = await _myAccountRepository
    //     //   //     .fetchMyAccount();
    //     //
    //      if (event.firstName!=null) {
    //         if (currentState is MyAccountLoaded) {
    //        if(user!=null) {
    //          yield currentState.copyWith(
    //               listUsers: [user],
    //               updateMyAccountInProgress: true
    //           );
    //        }
    //         }
    //
    //         try {
    //           Navigator.of(event.context!, rootNavigator: true).pop('dialog');
    //         } catch (e) {
    //           print(e);
    //         }
    //       // }
    //     } else {
    //     Navigator.pop(event.context!);
    //       add(EditMyAccountFailure());
    //     }
    //   } else {
    //     // Navigator.pop(event.context);
    //   }
      if (event.firstName.isNotEmpty || event.lastName.isNotEmpty || event.userName.isNotEmpty) {
        final currentState = state;

        if (currentState is MyAccountLoaded) {
          yield currentState.copyWith();
        }

        final Map myAccountData = await _myAccountRepository.updateMyAccountFromApi(
          firstName: event.firstName,
          lastName: event.lastName,
          jobTitle: event.userName,
          id: event.id,
        );

        if (myAccountData['errors'] == null) {
          final User myAccountData = await _myAccountRepository.getUserById(2.toString());

          if (currentState is MyAccountLoaded) {
            yield currentState.copyWith(
                listUsers: [myAccountData],
            );
          }

          try{
            Navigator.of(event.context!).pushAndRemoveUntil(

                MaterialPageRoute(
                    builder: (context) =>
                    const UsersScreen()),
                    (Route<dynamic> route) =>
                false);
          } catch(e) {
            debugPrint('$e');
          }
        } else {
          Navigator.pop(event.context!);
          add(EditMyAccountFailure());
        }
      } else {
        Navigator.pop(event.context!);
      }
    }

    Stream<EditUserState> _mapEditMyAccountFailureToState(
        EditMyAccountFailure event) async* {
      final currentState = state;

      if (currentState is MyAccountLoaded) {
        yield currentState.copyWith(
            updateMyAccountInProgress: false
        );
      }
    }
  }



// import 'package:bloc/bloc.dart';
// import 'package:work_timing/services/blocs/user/user_event.dart';
// import 'package:work_timing/services/blocs/user/user_state.dart';
// import 'package:work_timing/services/data_provider/user_data_provider.dart';
//
// import '../../models/user.dart';
//
//
//
// class EditTodoBloc extends Bloc<EditUserEvent, EditUserState> {
//   EditTodoBloc({
//      UserDataProvider? userDataProvider,
//      User? initialTodo,
//   })  : _userDataProvider = userDataProvider!,
//         super(
//         EditUserState(
//           initialTodo: initialTodo,
//           email:initialTodo?.email?? '',
//           fullName:initialTodo?.fullName?? '',
//         ),
//       ) {
//     on<EditUser>(_onTitleChanged);
//     on<EditUserSubmitted>(_onSubmitted);
//   }
//
//   final UserDataProvider _userDataProvider;
//
//   void _onTitleChanged(
//       EditUser event,
//       Emitter<EditUserState> emit,
//       ) {
//     emit(state.copyWith(fullName: event.fullName,email: event.email));
//   }
//
//
//
//   Future<void> _onSubmitted(
//       EditUserSubmitted event,
//       Emitter<EditUserState> emit,
//       ) async {
//     emit(state.copyWith(status: UserStatus.loading));
//     final user = (state.initialTodo ?? const User(fullName: '')).copyWith(
//       fullName: state.fullName,
//       email: state.email,
//
//     );
//
//     try {
//     await _userDataProvider.saveFavorite(user);
//       emit(state.copyWith(status: UserStatus.success));
//     } catch (e) {
//       emit(state.copyWith(status: UserStatus.failure));
//     }
//   }
// }