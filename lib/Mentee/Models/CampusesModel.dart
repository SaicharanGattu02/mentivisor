class CampusesModel {
  bool? status;
  PaginationData? data;

  CampusesModel({this.status, this.data});

  CampusesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? PaginationData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data?.toJson(),
    };
  }
}

class PaginationData {
  int? currentPage;
  List<CampusData>? campuses;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<dynamic>? links;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  PaginationData({
    this.currentPage,
    this.campuses,
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

  PaginationData.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];

    // campuses list
    campuses = json['data'] != null
        ? (json['data'] as List)
        .map((e) => CampusData.fromJson(e))
        .toList()
        : [];

    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    links = json['links'];
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'] is int
        ? json['per_page']
        : int.tryParse(json['per_page'].toString());
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'data': campuses?.map((e) => e.toJson()).toList(),
      'first_page_url': firstPageUrl,
      'from': from,
      'last_page': lastPage,
      'last_page_url': lastPageUrl,
      'links': links,
      'next_page_url': nextPageUrl,
      'path': path,
      'per_page': perPage,
      'prev_page_url': prevPageUrl,
      'to': to,
      'total': total,
    };
  }
}

class CampusData {
  int? id;
  String? name;
  String? state;
  String? city;
  String? dist;
  String? pincode;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  int? activeStatus;

  CampusData({
    this.id,
    this.name,
    this.state,
    this.city,
    this.dist,
    this.pincode,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.activeStatus,
  });

  CampusData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['Name'];
    state = json['State'];
    city = json['City'];
    dist = json['Dist'];
    pincode = json['pincode'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    activeStatus = json['active_status'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'Name': name,
      'State': state,
      'City': city,
      'Dist': dist,
      'pincode': pincode,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'active_status': activeStatus,
    };
  }
}
