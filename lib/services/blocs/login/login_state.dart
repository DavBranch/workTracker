import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import '../../fileds_validations/email.dart';
import '../../fileds_validations/password.dart';

class LoginState extends Equatable {
  const LoginState({
    this.userName = const UserName.pure(),
    this.password = const Password.pure(),
    this.status = FormzStatus.pure,
    this.isUser,
    this.errorMessage,
  });

  final UserName userName;
  final String? errorMessage;
  final bool? isUser;
  final Password password;
  final FormzStatus status;

  @override
  List<Object?> get props => [userName, password, status, errorMessage,isUser];

  LoginState copyWith({
    UserName? email,
    Password? password,
    FormzStatus? status,
    bool? isUser,
    String? errorMessage,
  }) {
    print("from Login State : $status");
    return LoginState(
      isUser: isUser ?? this.isUser,
      userName: email ?? this.userName,
      password: password ?? this.password,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}