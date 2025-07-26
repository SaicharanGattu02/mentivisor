import 'package:mentivisor/bloc/Expertise/ExpertiseRepository.dart';

import '../../Models/ExpertiseRespModel.dart';

abstract class Expertisestate {}

class expertiseStateIntially extends Expertisestate {}

class expertiseStateLoading extends Expertisestate {}

class expertiseStateLoaded extends Expertisestate {
  ExpertiseRespModel expertiseRespModel;
  expertiseStateLoaded({required this.expertiseRespModel});
}

class expertiseStateFailure extends Expertisestate {
  final String msg;

  expertiseStateFailure({required this.msg});


}