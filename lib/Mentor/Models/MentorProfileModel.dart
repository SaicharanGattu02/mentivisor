class MentorprofileModel {
  bool? status;
  String? message;
  Data? data;

  MentorprofileModel({this.status, this.message, this.data});

  MentorprofileModel.fromJson(Map<String, dynamic> json) {
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
  int? id;
  String? name;
  String? email;
  dynamic phone;
  String? profilePic;
  int? collegeId;
  String? collegeName;
  int? yearId;
  String? yearName;
  String? stream;
  String? bio;
  String? reasonForBecomeMentor;
  String? achivements;
  String? portfolio;
  String? linkedIn;
  String? gitHub;
  String? resume;
  List<String>? languages;
  String? coinsPerMinute;
  List<Expertise>? expertise;

  Data({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.profilePic,
    this.collegeId,
    this.collegeName,
    this.yearId,
    this.yearName,
    this.stream,
    this.bio,
    this.reasonForBecomeMentor,
    this.achivements,
    this.portfolio,
    this.linkedIn,
    this.gitHub,
    this.resume,
    this.languages,
    this.coinsPerMinute,
    this.expertise,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    profilePic = json['profile_pic'];
    collegeId = json['college_id'];
    collegeName = json['college_name'];
    yearId = json['year_id'];
    yearName = json['year_name'];
    stream = json['stream'];
    bio = json['bio'];
    reasonForBecomeMentor = json['reason_for_become_mentor'];
    achivements = json['achivements'];
    portfolio = json['portfolio'];
    linkedIn = json['linked_in'];
    gitHub = json['git_hub'];
    resume = json['resume'];
    languages = json['languages'].cast<String>();
    coinsPerMinute = json['coins_per_minute'];
    if (json['expertise'] != null) {
      expertise = <Expertise>[];
      json['expertise'].forEach((v) {
        expertise!.add(new Expertise.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['profile_pic'] = this.profilePic;
    data['college_id'] = this.collegeId;
    data['college_name'] = this.collegeName;
    data['year_id'] = this.yearId;
    data['year_name'] = this.yearName;
    data['stream'] = this.stream;
    data['bio'] = this.bio;
    data['reason_for_become_mentor'] = this.reasonForBecomeMentor;
    data['achivements'] = this.achivements;
    data['portfolio'] = this.portfolio;
    data['linked_in'] = this.linkedIn;
    data['git_hub'] = this.gitHub;
    data['resume'] = this.resume;
    data['languages'] = this.languages;
    data['coins_per_minute'] = this.coinsPerMinute;
    if (this.expertise != null) {
      data['expertise'] = this.expertise!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Expertise {
  int? id;
  String? name;
  int? baseValue;
  String? createdAt;
  String? updatedAt;   // FIXED: changed from Null? to String?
  String? deletedAt;   // FIXED: changed from Null? to String?
  int? activeStatus;
  Pivot? pivot;
  List<SubExpertises>? subExpertises;

  Expertise({
    this.id,
    this.name,
    this.baseValue,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.activeStatus,
    this.pivot,
    this.subExpertises,
  });

  Expertise.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    baseValue = json['base_value'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    activeStatus = json['active_status'];
    pivot = json['pivot'] != null ? Pivot.fromJson(json['pivot']) : null;
    if (json['sub_expertises'] != null) {
      subExpertises = <SubExpertises>[];
      json['sub_expertises'].forEach((v) {
        subExpertises!.add(SubExpertises.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['base_value'] = baseValue;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['active_status'] = activeStatus;
    if (pivot != null) {
      data['pivot'] = pivot!.toJson();
    }
    if (subExpertises != null) {
      data['sub_expertises'] =
          subExpertises!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class Pivot {
  int? mentorId;
  int? expertiseId;

  Pivot({this.mentorId, this.expertiseId});

  Pivot.fromJson(Map<String, dynamic> json) {
    mentorId = json['mentor_id'];
    expertiseId = json['expertise_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mentor_id'] = this.mentorId;
    data['expertise_id'] = this.expertiseId;
    return data;
  }
}

class SubExpertises {
  int? id;
  int? expertiseId;
  String? name;

  SubExpertises({this.id, this.expertiseId, this.name});

  SubExpertises.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    expertiseId = json['expertise_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['expertise_id'] = this.expertiseId;
    data['name'] = this.name;
    return data;
  }
}
