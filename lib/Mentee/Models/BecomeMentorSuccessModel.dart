class BecomeMentorSuccessModel {
  bool? status;
  String? message;
  Data? data;
  int? coinsPerMinute;

  BecomeMentorSuccessModel(
      {this.status, this.message, this.data, this.coinsPerMinute});

  BecomeMentorSuccessModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    coinsPerMinute = json['coins_per_minute'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['coins_per_minute'] = this.coinsPerMinute;
    return data;
  }
}

class Data {
  int? userId;
  String? reasonForBecomeMentor;
  String? achivements;
  String? portfolio;
  String? linkedIn;
  String? gitHub;
  String? resume;
  List<String>? langages;
  int? coinsPerMinute;
  String? updatedAt;
  String? createdAt;
  int? id;

  Data(
      {this.userId,
        this.reasonForBecomeMentor,
        this.achivements,
        this.portfolio,
        this.linkedIn,
        this.gitHub,
        this.resume,
        this.langages,
        this.coinsPerMinute,
        this.updatedAt,
        this.createdAt,
        this.id});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    reasonForBecomeMentor = json['reason_for_become_mentor'];
    achivements = json['achivements'];
    portfolio = json['portfolio'];
    linkedIn = json['linked_in'];
    gitHub = json['git_hub'];
    resume = json['resume'];
    langages = json['langages'].cast<String>();
    coinsPerMinute = json['coins_per_minute'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['reason_for_become_mentor'] = this.reasonForBecomeMentor;
    data['achivements'] = this.achivements;
    data['portfolio'] = this.portfolio;
    data['linked_in'] = this.linkedIn;
    data['git_hub'] = this.gitHub;
    data['resume'] = this.resume;
    data['langages'] = this.langages;
    data['coins_per_minute'] = this.coinsPerMinute;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}
