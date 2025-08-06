import 'package:mentivisor/Models/EccGuestlist_Model.dart';

abstract class Eccguestliststate {}

class EccguestlistStateIntially extends Eccguestliststate {}

class EccguestlistStateLoading extends Eccguestliststate {}

class EccguestlistStateLoaded extends Eccguestliststate {
  EccGuestlist_Model eccGuestlist_Model;
  EccguestlistStateLoaded({required this.eccGuestlist_Model});
}

class EccguestlistStateFailure extends Eccguestliststate {
  final String msg;
  EccguestlistStateFailure({required this.msg});

}