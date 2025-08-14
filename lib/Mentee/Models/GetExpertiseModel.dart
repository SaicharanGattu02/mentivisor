class GetExpertiseModel {
  bool? status;
  ExpertisePagination? data;

  GetExpertiseModel({this.status, this.data});

  GetExpertiseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null
        ? ExpertisePagination.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataMap = {};
    dataMap['status'] = status;
    if (data != null) {
      dataMap['data'] = data!.toJson();
    }
    return dataMap;
  }
}

class ExpertisePagination {
  int? currentPage;
  List<ExpertiseData>? data;
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

  ExpertisePagination({
    this.currentPage,
    this.data,
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

  ExpertisePagination.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <ExpertiseData>[];
      json['data'].forEach((v) {
        data!.add(ExpertiseData.fromJson(v));
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
    final Map<String, dynamic> dataMap = {};
    dataMap['current_page'] = currentPage;
    if (data != null) {
      dataMap['data'] = data!.map((v) => v.toJson()).toList();
    }
    dataMap['first_page_url'] = firstPageUrl;
    dataMap['from'] = from;
    dataMap['last_page'] = lastPage;
    dataMap['last_page_url'] = lastPageUrl;
    if (links != null) {
      dataMap['links'] = links!.map((v) => v.toJson()).toList();
    }
    dataMap['next_page_url'] = nextPageUrl;
    dataMap['path'] = path;
    dataMap['per_page'] = perPage;
    dataMap['prev_page_url'] = prevPageUrl;
    dataMap['to'] = to;
    dataMap['total'] = total;
    return dataMap;
  }
}

class ExpertiseData {
  int? id;
  String? name;
  int? baseValue;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  int? activeStatus;
  List<SubExpertises>? subExpertises;

  ExpertiseData({
    this.id,
    this.name,
    this.baseValue,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.activeStatus,
    this.subExpertises,
  });

  ExpertiseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    baseValue = json['base_value'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    activeStatus = json['active_status'];
    if (json['sub_expertises'] != null) {
      subExpertises = <SubExpertises>[];
      json['sub_expertises'].forEach((v) {
        subExpertises!.add(SubExpertises.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataMap = {};
    dataMap['id'] = id;
    dataMap['name'] = name;
    dataMap['base_value'] = baseValue;
    dataMap['created_at'] = createdAt;
    dataMap['updated_at'] = updatedAt;
    dataMap['deleted_at'] = deletedAt;
    dataMap['active_status'] = activeStatus;
    if (subExpertises != null) {
      dataMap['sub_expertises'] =
          subExpertises!.map((v) => v.toJson()).toList();
    }
    return dataMap;
  }
}

class SubExpertises {
  int? id;
  String? name;
  int? expertiseId;
  int? baseValue;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  int? activeStatus;

  SubExpertises({
    this.id,
    this.name,
    this.expertiseId,
    this.baseValue,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.activeStatus,
  });

  SubExpertises.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    expertiseId = json['expertise_id'];
    baseValue = json['base_value'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    activeStatus = json['active_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataMap = {};
    dataMap['id'] = id;
    dataMap['name'] = name;
    dataMap['expertise_id'] = expertiseId;
    dataMap['base_value'] = baseValue;
    dataMap['created_at'] = createdAt;
    dataMap['updated_at'] = updatedAt;
    dataMap['deleted_at'] = deletedAt;
    dataMap['active_status'] = activeStatus;
    return dataMap;
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
    final Map<String, dynamic> dataMap = {};
    dataMap['url'] = url;
    dataMap['label'] = label;
    dataMap['active'] = active;
    return dataMap;
  }
}
