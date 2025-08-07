import 'package:equatable/equatable.dart';
import 'package:mentivisor/Models/LoginResponseModel.dart';

abstract class LoginState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginIntially extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSucess extends LoginState {
  final LogInModel logInModel;
  LoginSucess({required this.logInModel});
}

class LoginFailure extends LoginState {
  final String message;
  LoginFailure({required this.message});
}
