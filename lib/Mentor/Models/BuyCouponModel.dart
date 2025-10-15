class BuyCouponModel {
  bool? status;
  String? message;
  Data? data;

  BuyCouponModel({this.status, this.message, this.data});

  BuyCouponModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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

class Data {
  Coupon? coupon;
  String? code;

  Data({this.coupon, this.code});

  Data.fromJson(Map<String, dynamic> json) {
    coupon =
    json['coupon'] != null ? new Coupon.fromJson(json['coupon']) : null;
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.coupon != null) {
      data['coupon'] = this.coupon!.toJson();
    }
    data['code'] = this.code;
    return data;
  }
}

class Coupon {
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

  Coupon(
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
        this.updatedAt});

  Coupon.fromJson(Map<String, dynamic> json) {
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
    coinsRequired = json['coins_required'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
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
    return data;
  }
}
