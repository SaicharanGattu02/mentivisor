class ExpertisesModel {
  bool? status;
  String? message;
  Data? data;

  ExpertisesModel({this.status, this.message, this.data});

  ExpertisesModel.fromJson(Map<String, dynamic> json) {
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
  String? coinsPerMinute;
  List<Expertises>? expertises;
  List<SubExpertises>? subExpertises;

  Data({this.coinsPerMinute, this.expertises, this.subExpertises});

  Data.fromJson(Map<String, dynamic> json) {
    coinsPerMinute = json['coins_per_minute'];
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['coins_per_minute'] = this.coinsPerMinute;
    if (this.expertises != null) {
      data['expertises'] = this.expertises!.map((v) => v.toJson()).toList();
    }
    if (this.subExpertises != null) {
      data['sub_expertises'] =
          this.subExpertises!.map((v) => v.toJson()).toList();
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
  int? baseValue;
  bool? attached;

  SubExpertises(
      {this.id, this.expertiseId, this.name, this.baseValue, this.attached});

  SubExpertises.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    expertiseId = json['expertise_id'];
    name = json['name'];
    baseValue = json['base_value'];
    attached = json['attached'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['expertise_id'] = this.expertiseId;
    data['name'] = this.name;
    data['base_value'] = this.baseValue;
    data['attached'] = this.attached;
    return data;
  }
}
