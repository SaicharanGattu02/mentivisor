class ECCModel {
  bool? status;
  Data? data;

  ECCModel({this.status, this.data});

  ECCModel.fromJson(Map<String, dynamic> json) {
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
  int? currentPage;
  List<ECCList>? ecclist;
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
    this.ecclist,
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
      ecclist = <ECCList>[];
      json['data'].forEach((v) {
        ecclist!.add(new ECCList.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(new Links.fromJson(v));
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    if (this.ecclist != null) {
      data['data'] = this.ecclist!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = this.firstPageUrl;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['last_page_url'] = this.lastPageUrl;
    if (this.links != null) {
      data['links'] = this.links!.map((v) => v.toJson()).toList();
    }
    data['next_page_url'] = this.nextPageUrl;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['prev_page_url'] = this.prevPageUrl;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}

class ECCList {
  int? id;
  String? name;
  String? location;
  String? type;
  String? time;
  String? dateofevent;
  Null? tags;
  String? college;
  String? description;
  String? link;
  String? image;
  int? popular;
  int? uploadedBy;
  int? collegeId;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;
  int? activeStatus;
  String? imgUrl;

  ECCList({
    this.id,
    this.name,
    this.location,
    this.type,
    this.time,
    this.dateofevent,
    this.tags,
    this.college,
    this.description,
    this.link,
    this.image,
    this.popular,
    this.uploadedBy,
    this.collegeId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.activeStatus,
    this.imgUrl,
  });

  ECCList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    location = json['location'];
    type = json['type'];
    time = json['time'];
    dateofevent = json['dateofevent'];
    tags = json['tags'];
    college = json['college'];
    description = json['description'];
    link = json['link'];
    image = json['image'];
    popular = json['popular'];
    uploadedBy = json['uploaded_by'];
    collegeId = json['college_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    activeStatus = json['active_status'];
    imgUrl = json['img_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['location'] = this.location;
    data['type'] = this.type;
    data['time'] = this.time;
    data['dateofevent'] = this.dateofevent;
    data['tags'] = this.tags;
    data['college'] = this.college;
    data['description'] = this.description;
    data['link'] = this.link;
    data['image'] = this.image;
    data['popular'] = this.popular;
    data['uploaded_by'] = this.uploadedBy;
    data['college_id'] = this.collegeId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['active_status'] = this.activeStatus;
    data['img_url'] = this.imgUrl;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['label'] = this.label;
    data['active'] = this.active;
    return data;
  }
}
