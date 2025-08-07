import 'package:equatable/equatable.dart';
import '../../../Models/RegisterModel.dart';

abstract class RegisterState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RegisterIntially extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSucess extends RegisterState {
  final RegisterModel registerModel;
  RegisterSucess({required this.registerModel});
}

class RegisterFailure extends RegisterState {
  final String message;
  RegisterFailure({required this.message});
}