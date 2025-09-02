import 'package:equatable/equatable.dart';
import '../../../Models/ExpertisesModel.dart';

abstract class ExpertiseState extends Equatable {
  const ExpertiseState();
  @override
  List<Object?> get props => [];
}

class ExpertiseInitially extends ExpertiseState {}

class ExpertiseLoading extends ExpertiseState {}

class ExpertiseLoaded extends ExpertiseState {
  final ExpertisesModel model;
  const ExpertiseLoaded(this.model);
  @override
  List<Object?> get props => [model];
}

class ExpertiseFailure extends ExpertiseState {
  final String message;
  const ExpertiseFailure(this.message);
  @override
  List<Object?> get props => [message];
}
