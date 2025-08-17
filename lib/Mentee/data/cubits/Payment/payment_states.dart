

import '../../../Models/CreatePaymentModel.dart';

abstract class PaymentStates {}

class PaymentInitially extends PaymentStates {}

class PaymentLoading extends PaymentStates {}

class PaymentCreated extends PaymentStates {
  CreatePaymentModel createPaymentModel;
  PaymentCreated(this.createPaymentModel);
}

class PaymentVerified extends PaymentStates {
  // VerifyPaymentModel verifyPaymentModel;
  PaymentVerified();
}

class PaymentFailure extends PaymentStates {
  String error;
  PaymentFailure(this.error);
}
