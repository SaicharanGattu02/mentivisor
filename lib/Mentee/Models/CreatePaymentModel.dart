class CreatePaymentModel {
  bool? status;
  String? orderId;
  int? amount;
  String? currency;
  String? rAZORPAYKEY;
  String? msg;

  CreatePaymentModel({this.status, this.orderId, this.amount, this.currency, this.msg,this.rAZORPAYKEY});

  CreatePaymentModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    orderId = json['order_id'];
    amount = json['amount'];
    currency = json['currency'];
    rAZORPAYKEY = json['RAZORPAY_KEY'];
    msg = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['order_id'] = this.orderId;
    data['amount'] = this.amount;
    data['currency'] = this.currency;
    data['RAZORPAY_KEY'] = this.rAZORPAYKEY;
    data['error'] = this.msg;
    return data;
  }
}
