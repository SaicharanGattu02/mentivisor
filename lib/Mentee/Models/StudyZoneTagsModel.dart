class StudyZoneTagsModel {
  bool? status;
  List<StudyZone>? data;

  StudyZoneTagsModel({this.status, this.data});

  StudyZoneTagsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <StudyZone>[];
      json['data'].forEach((v) {
        data!.add(new StudyZone.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StudyZone {
  int? id;
  String? tags;

  StudyZone({this.id, this.tags});

  StudyZone.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tags = json['tags'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tags'] = this.tags;
    return data;
  }
}
