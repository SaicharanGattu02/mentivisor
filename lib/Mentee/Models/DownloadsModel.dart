class DownloadsModel {
  bool? status;
  Data? data;

  DownloadsModel({this.status, this.data});

  DownloadsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? currentPage;
  List<Downloads>? downloads;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Links>? links;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  Data({
    this.currentPage,
    this.downloads,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  Data.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      downloads = <Downloads>[];
      json['data'].forEach((v) {
        downloads!.add(Downloads.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(Links.fromJson(v));
      });
    }
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['current_page'] = currentPage;
    if (downloads != null) {
      data['data'] = downloads!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = firstPageUrl;
    data['from'] = from;
    data['last_page'] = lastPage;
    data['last_page_url'] = lastPageUrl;
    if (links != null) {
      data['links'] = links!.map((v) => v.toJson()).toList();
    }
    data['next_page_url'] = nextPageUrl;
    data['path'] = path;
    data['per_page'] = perPage;
    data['prev_page_url'] = prevPageUrl;
    data['to'] = to;
    data['total'] = total;
    return data;
  }
}

class Downloads {
  int? downloadId;
  String? description;
  List<String>? tag;
  String? title;
  String? filePath;
  String? image;
  String? downloadedAt;

  Downloads({
    this.downloadId,
    this.description,
    this.tag,
    this.title,
    this.filePath,
    this.image,
    this.downloadedAt,
  });

  Downloads.fromJson(Map<String, dynamic> json) {
    downloadId = json['download_id'];
    description = json['description'];
    if (json['tag'] != null) {
      // If tag is a single string, wrap it in a list; else cast it safely
      if (json['tag'] is List) {
        tag = List<String>.from(json['tag']);
      } else if (json['tag'] is String) {
        tag = [json['tag']];
      }
    } else {
      tag = []; // Default empty list when null
    }
    title = json['title'];
    filePath = json['file_path'];
    image = json['image'];
    downloadedAt = json['downloaded_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['download_id'] = downloadId;
    data['description'] = description;
    data['tag'] = tag;
    data['title'] = title;
    data['file_path'] = filePath;
    data['image'] = image;
    data['downloaded_at'] = downloadedAt;
    return data;
  }
}

class Links {
  String? url;
  String? label;
  bool? active;

  Links({this.url, this.label, this.active});

  Links.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['url'] = url;
    data['label'] = label;
    data['active'] = active;
    return data;
  }
}
