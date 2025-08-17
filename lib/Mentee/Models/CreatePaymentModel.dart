class CreatePaymentModel {
  bool? status;
  String? orderId;
  int? amount;
  String? currency;
  String? msg;

  CreatePaymentModel({this.status, this.orderId, this.amount, this.currency, this.msg});

  CreatePaymentModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    orderId = json['order_id'];
    amount = json['amount'];
    currency = json['currency'];
    msg = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['order_id'] = this.orderId;
    data['amount'] = this.amount;
    data['currency'] = this.currency;
    data['error'] = this.msg;
    return data;
  }
}
