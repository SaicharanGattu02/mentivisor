class MentorEarningsModel {
  bool? status;
  String? message;
  Data? data;

  MentorEarningsModel({this.status, this.message, this.data});

  MentorEarningsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  dynamic currentBalance;
  dynamic thisMonthEarnings;

  Data({this.currentBalance, this.thisMonthEarnings});

  Data.fromJson(Map<String, dynamic> json) {
    currentBalance = json['Current Balance'];
    thisMonthEarnings = json['This Month Earnings'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Current Balance'] = this.currentBalance;
    data['This Month Earnings'] = this.thisMonthEarnings;
    return data;
  }
}
