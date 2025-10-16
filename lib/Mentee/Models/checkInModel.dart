class checkInModel {
  bool? success;
  int? streak;
  bool? rewarded;
  String? message;

  checkInModel({this.success, this.streak, this.rewarded, this.message});

  checkInModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    streak = json['streak'];
    rewarded = json['rewarded'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['streak'] = this.streak;
    data['rewarded'] = this.rewarded;
    data['message'] = this.message;
    return data;
  }
}
