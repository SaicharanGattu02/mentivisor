class MentorExpertiseModel {
  bool? status;
  String? message;
  MentorExpertiseData? data;

  MentorExpertiseModel({this.status, this.message, this.data});

  factory MentorExpertiseModel.fromJson(Map<String, dynamic> json) {
    return MentorExpertiseModel(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null
          ? MentorExpertiseData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (data != null) {
      map['data'] = data!.toJson();
    }
    return map;
  }
}

class MentorExpertiseData {
  String? coinsPerMinute;
  List<Expertise>? expertises;
  List<SubExpertise>? subExpertises;
  List<SubExpertise>? notAttachedSubExpertises;

  MentorExpertiseData({
    this.coinsPerMinute,
    this.expertises,
    this.subExpertises,
    this.notAttachedSubExpertises,
  });

  factory MentorExpertiseData.fromJson(Map<String, dynamic> json) {
    return MentorExpertiseData(
      coinsPerMinute: json['coins_per_minute'],
      expertises: json['expertises'] != null
          ? List<Expertise>.from(
              json['expertises'].map((x) => Expertise.fromJson(x)),
            )
          : [],
      subExpertises: json['sub_expertises'] != null
          ? List<SubExpertise>.from(
              json['sub_expertises'].map((x) => SubExpertise.fromJson(x)),
            )
          : [],
      notAttachedSubExpertises: json['not_attached_sub_expertises'] != null
          ? List<SubExpertise>.from(
              json['not_attached_sub_expertises'].map(
                (x) => SubExpertise.fromJson(x),
              ),
            )
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['coins_per_minute'] = coinsPerMinute;
    if (expertises != null) {
      map['expertises'] = expertises!.map((x) => x.toJson()).toList();
    }
    if (subExpertises != null) {
      map['sub_expertises'] = subExpertises!.map((x) => x.toJson()).toList();
    }
    if (notAttachedSubExpertises != null) {
      map['not_attached_sub_expertises'] = notAttachedSubExpertises!
          .map((x) => x.toJson())
          .toList();
    }
    return map;
  }
}

class Expertise {
  int? id;
  String? name;

  Expertise({this.id, this.name});

  factory Expertise.fromJson(Map<String, dynamic> json) {
    return Expertise(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

class SubExpertise {
  int? id;
  int? expertiseId;
  String? name;
  int? baseValue;
  bool? attached;

  SubExpertise({
    this.id,
    this.expertiseId,
    this.name,
    this.baseValue,
    this.attached,
  });

  factory SubExpertise.fromJson(Map<String, dynamic> json) {
    return SubExpertise(
      id: json['id'],
      expertiseId: json['expertise_id'],
      name: json['name'],
      baseValue: json['base_value'],
      attached: json['attached'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'expertise_id': expertiseId,
      'name': name,
      'base_value': baseValue,
      'attached': attached,
    };
  }
}
