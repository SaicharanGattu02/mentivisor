class HighlightedCoinsModel {
  bool? status;
  String? message;   // added for error/message handling
  List<Data>? data;

  HighlightedCoinsModel({this.status, this.message, this.data});

  HighlightedCoinsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    // API might return either "message" or "error"
    message = json['message'] ?? json['error'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['status'] = status;
    map['message'] = message;
    if (data != null) {
      map['data'] = data!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}


class Data {
  int? id;
  String? category;
  String? coins;
  String? createdAt;
  String? updatedAt;

  Data({this.id, this.category, this.coins, this.createdAt, this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category = json['category'];
    coins = json['coins'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category'] = this.category;
    data['coins'] = this.coins;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
