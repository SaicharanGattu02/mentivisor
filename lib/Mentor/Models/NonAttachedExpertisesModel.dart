class NonAttachedExpertisesModel {
  bool? status;
  String? message;
  ExpertisesData? data;

  NonAttachedExpertisesModel({this.status, this.message, this.data});

  NonAttachedExpertisesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new ExpertisesData.fromJson(json['data']) : null;
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

class ExpertisesData {
  List<NotAttachedExpertises>? notAttachedExpertises;
  List<NotAttachedSubExpertises>? notAttachedSubExpertises;

  ExpertisesData({this.notAttachedExpertises, this.notAttachedSubExpertises});

  ExpertisesData.fromJson(Map<String, dynamic> json) {
    if (json['not_attached_expertises'] != null) {
      notAttachedExpertises = <NotAttachedExpertises>[];
      json['not_attached_expertises'].forEach((v) {
        notAttachedExpertises!.add(new NotAttachedExpertises.fromJson(v));
      });
    }
    if (json['not_attached_sub_expertises'] != null) {
      notAttachedSubExpertises = <NotAttachedSubExpertises>[];
      json['not_attached_sub_expertises'].forEach((v) {
        notAttachedSubExpertises!.add(new NotAttachedSubExpertises.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.notAttachedExpertises != null) {
      data['not_attached_expertises'] =
          this.notAttachedExpertises!.map((v) => v.toJson()).toList();
    }
    if (this.notAttachedSubExpertises != null) {
      data['not_attached_sub_expertises'] =
          this.notAttachedSubExpertises!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NotAttachedExpertises {
  int? id;
  String? name;

  NotAttachedExpertises({this.id, this.name});

  NotAttachedExpertises.fromJson(Map<String, dynamic> json) {
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

class NotAttachedSubExpertises {
  int? id;
  int? expertiseId;
  String? name;
  int? baseValue;

  NotAttachedSubExpertises(
      {this.id, this.expertiseId, this.name, this.baseValue});

  NotAttachedSubExpertises.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    expertiseId = json['expertise_id'];
    name = json['name'];
    baseValue = json['base_value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['expertise_id'] = this.expertiseId;
    data['name'] = this.name;
    data['base_value'] = this.baseValue;
    return data;
  }
}
