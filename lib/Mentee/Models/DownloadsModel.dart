class DownloadsModel {
  bool? status;
  List<Downloads>? downloads;

  DownloadsModel({this.status, this.downloads});

  DownloadsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      downloads = <Downloads>[];
      json['data'].forEach((v) {
        downloads!.add(new Downloads.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.downloads != null) {
      data['data'] = this.downloads!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Downloads {
  int? downloadId;
  String? description;
  List<String>? tag;
  String? title;
  String? filePath;
  String? downloadedAt;

  Downloads({
    this.downloadId,
    this.description,
    this.tag,
    this.title,
    this.filePath,
    this.downloadedAt,
  });

  Downloads.fromJson(Map<String, dynamic> json) {
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
