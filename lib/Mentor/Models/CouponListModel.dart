class CouponListModel {
  bool? status;
  String? message;
  CouponsList? couponsList;

  CouponListModel({this.status, this.message, this.couponsList});

  CouponListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    couponsList = json['data'] != null ? new CouponsList.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.couponsList != null) {
      data['data'] = this.couponsList!.toJson();
    }
    return data;
  }
}

class CouponsList {
  int? currentPage;
  List<Data>? data;
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

  CouponsList(
      {this.currentPage,
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
        this.total});

  CouponsList.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
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

class Data {
  int? id;
  int? categoryId;
  String? vendor;
  String? website;
  String? title;
  String? description;
  String? image;
  String? purchaseValue;
  String? actualValue;
  int? totalCoupons;
  String? startDate;
  String? expiryDate;
  int? coinsRequired;
  String? createdAt;
  String? updatedAt;
  Category? category;

  Data(
      {this.id,
        this.categoryId,
        this.vendor,
        this.website,
        this.title,
        this.description,
        this.image,
        this.purchaseValue,
        this.actualValue,
        this.totalCoupons,
        this.startDate,
        this.expiryDate,
        this.coinsRequired,
        this.createdAt,
        this.updatedAt,
        this.category});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    vendor = json['vendor'];
    website = json['website'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    purchaseValue = json['purchase_value'];
    actualValue = json['actual_value'];
    totalCoupons = json['total_coupons'];
    startDate = json['start_date'];
    expiryDate = json['expiry_date'];
    coinsRequired= json['coins_required'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_id'] = this.categoryId;
    data['vendor'] = this.vendor;
    data['website'] = this.website;
    data['title'] = this.title;
    data['description'] = this.description;
    data['image'] = this.image;
    data['purchase_value'] = this.purchaseValue;
    data['actual_value'] = this.actualValue;
    data['total_coupons'] = this.totalCoupons;
    data['start_date'] = this.startDate;
    data['expiry_date'] = this.expiryDate;
    data['coins_required'] = this.coinsRequired;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    return data;
  }
}

class Category {
  int? id;
  String? name;

  Category({this.id, this.name});

  Category.fromJson(Map<String, dynamic> json) {
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
