class UpdateExpertiseModel {
  bool? status;
  String? message;
  Data? data;
  int? coins;

  UpdateExpertiseModel({this.status, this.message, this.data, this.coins});

  UpdateExpertiseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    coins = json['coins'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['coins'] = this.coins;
    return data;
  }
}

class Data {
  int? mentorId;
  List<String>? expertiseId;
  List<String>? subExpertiseIds;
  String? proofLink;
  String? proofDoc;
  String? status;
  String? updatedAt;
  String? createdAt;
  int? id;

  Data(
      {this.mentorId,
        this.expertiseId,
        this.subExpertiseIds,
        this.proofLink,
        this.proofDoc,
        this.status,
        this.updatedAt,
        this.createdAt,
        this.id});

  Data.fromJson(Map<String, dynamic> json) {
    mentorId = json['mentor_id'];
    expertiseId = json['expertise_id'].cast<String>();
    subExpertiseIds = json['sub_expertise_ids'].cast<String>();
    proofLink = json['proof_link'];
    proofDoc = json['proof_doc'];
    status = json['status'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mentor_id'] = this.mentorId;
    data['expertise_id'] = this.expertiseId;
    data['sub_expertise_ids'] = this.subExpertiseIds;
    data['proof_link'] = this.proofLink;
    data['proof_doc'] = this.proofDoc;
    data['status'] = this.status;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}
