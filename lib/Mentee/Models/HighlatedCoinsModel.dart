class HighlightedCoinsModel {
  bool? status;
  Data? data;

  HighlightedCoinsModel({this.status, this.data});

  HighlightedCoinsModel.fromJson(Map<String, dynamic> json) {
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
  int? coins;

  Data({this.coins});

  Data.fromJson(Map<String, dynamic> json) {
    coins = json['coins'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['coins'] = this.coins;
    return data;
  }
}
