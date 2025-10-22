class RedeemedCouponsModel {
  bool? status;
  String? message;
  Coupons? data;

  RedeemedCouponsModel({this.status, this.message, this.data});

  RedeemedCouponsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Coupons.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Coupons {
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

  Coupons({
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

  Coupons.fromJson(Map<String, dynamic> json) {
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
  int? userId;
  int? couponId;
  String? title;
  String? code;
  String? coins;
  String? vendor;
  String? website;
  String? createdAt;
  String? updatedAt;
  Coupon? coupon;

  Data({
    this.id,
    this.userId,
    this.couponId,
    this.title,
    this.code,
    this.vendor,
    this.website,
    this.coins,
    this.createdAt,
    this.updatedAt,
    this.coupon,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    couponId = json['coupon_id'];
    title = json['title'];
    code = json['code'];
    vendor = json['vendor'];
    website = json['website'];
    coins = json['coins'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    coupon = json['coupon'] != null
        ? new Coupon.fromJson(json['coupon'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['coupon_id'] = this.couponId;
    data['title'] = this.title;
    data['code'] = this.code;
    data['vendor'] = this.vendor;
    data['coins'] = this.coins;
    data['website'] = this.website;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.coupon != null) {
      data['coupon'] = this.coupon!.toJson();
    }
    return data;
  }
}

class Coupon {
  int? id;
  String? actualValue;

  Coupon({this.id, this.actualValue});

  Coupon.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    actualValue = json['actual_value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['actual_value'] = this.actualValue;
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
