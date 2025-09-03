class PendingSubExpertisesModel {
  bool? status;
  Data? data;

  PendingSubExpertisesModel({this.status, this.data});

  PendingSubExpertisesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? status;
  List<Expertises>? expertises;
  List<SubExpertises>? subExpertises;
  String? proofLink;
  String? proofDoc;
  Mentor? mentor;

  Data(
      {this.id,
        this.status,
        this.expertises,
        this.subExpertises,
        this.proofLink,
        this.proofDoc,
        this.mentor});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    if (json['expertises'] != null) {
      expertises = <Expertises>[];
      json['expertises'].forEach((v) {
        expertises!.add(new Expertises.fromJson(v));
      });
    }
    if (json['sub_expertises'] != null) {
      subExpertises = <SubExpertises>[];
      json['sub_expertises'].forEach((v) {
        subExpertises!.add(new SubExpertises.fromJson(v));
      });
    }
    proofLink = json['proof_link'];
    proofDoc = json['proof_doc'];
    mentor =
    json['mentor'] != null ? new Mentor.fromJson(json['mentor']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    if (this.expertises != null) {
      data['expertises'] = this.expertises!.map((v) => v.toJson()).toList();
    }
    if (this.subExpertises != null) {
      data['sub_expertises'] =
          this.subExpertises!.map((v) => v.toJson()).toList();
    }
    data['proof_link'] = this.proofLink;
    data['proof_doc'] = this.proofDoc;
    if (this.mentor != null) {
      data['mentor'] = this.mentor!.toJson();
    }
    return data;
  }
}

class Expertises {
  int? id;
  String? name;

  Expertises({this.id, this.name});

  Expertises.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
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

class Mentor {
  int? id;
  int? userId;
  String? name;
  String? email;
  String? profilePic;
  Null? college;

  Mentor(
      {this.id,
        this.userId,
        this.name,
        this.email,
        this.profilePic,
        this.college});

  Mentor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    email = json['email'];
    profilePic = json['profile_pic'];
    college = json['college'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['profile_pic'] = this.profilePic;
    data['college'] = this.college;
    return data;
  }
}
