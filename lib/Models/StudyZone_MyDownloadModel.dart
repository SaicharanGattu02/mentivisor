class StudyZone_MyDownloadModel {
  bool? status;
  List<Data>? data;

  StudyZone_MyDownloadModel({this.status, this.data});

  StudyZone_MyDownloadModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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

class Data {
  int? downloadId;
  String? description;
  List<String>? tag;
  String? title;
  String? filePath;
  String? downloadedAt;

  Data(
      {this.downloadId,
        this.description,
        this.tag,
        this.title,
        this.filePath,
        this.downloadedAt});

  Data.fromJson(Map<String, dynamic> json) {
    downloadId = json['download_id'];
    description = json['description'];
    tag = json['tag'].cast<String>();
    title = json['title'];
    filePath = json['file_path'];
    downloadedAt = json['downloaded_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['download_id'] = this.downloadId;
    data['description'] = this.description;
    data['tag'] = this.tag;
    data['title'] = this.title;
    data['file_path'] = this.filePath;
    data['downloaded_at'] = this.downloadedAt;
    return data;
  }
}
