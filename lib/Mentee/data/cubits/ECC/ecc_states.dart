import 'package:mentivisor/Mentee/Models/ECCModel.dart';

abstract class ECCStates {}

class ECCIntially extends ECCStates {}

class ECCLoading extends ECCStates {}

class ECCLoaded extends ECCStates {
  final ECCModel eccModel;
  final bool hasNextPage;

  ECCLoaded(this.eccModel, this.hasNextPage);
}

class ECCLoadingMore extends ECCStates {
  final ECCModel eccModel;
  final bool hasNextPage;

  ECCLoadingMore(this.eccModel, this.hasNextPage);
}

class ECCFailure extends ECCStates {
  String error;
  ECCFailure(this.error);
}
