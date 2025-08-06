class StudyZone_getTagsWL_Model {
  bool? status;
  List<String>? tags;

  StudyZone_getTagsWL_Model({this.status, this.tags});

  StudyZone_getTagsWL_Model.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    tags = json['tags'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['tags'] = this.tags;
    return data;
  }
}