class WalletModel {
  bool? status;
  Data? data;

  WalletModel({this.status, this.data});

  WalletModel.fromJson(Map<String, dynamic> json) {
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
  Wallet? wallet;
  Transactions? transactions;

  Data({this.wallet, this.transactions});

  Data.fromJson(Map<String, dynamic> json) {
    wallet =
    json['wallet'] != null ? new Wallet.fromJson(json['wallet']) : null;
    transactions = json['transactions'] != null
        ? new Transactions.fromJson(json['transactions'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.wallet != null) {
      data['wallet'] = this.wallet!.toJson();
    }
    if (this.transactions != null) {
      data['transactions'] = this.transactions!.toJson();
    }
    return data;
  }
}

class Wallet {
  String? totalEarned;
  String? totalSpent;
  String? currentBalance;

  Wallet({this.totalEarned, this.totalSpent, this.currentBalance});

  Wallet.fromJson(Map<String, dynamic> json) {
    totalEarned = json['total_earned'];
    totalSpent = json['total_spent'];
    currentBalance = json['current_balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_earned'] = this.totalEarned;
    data['total_spent'] = this.totalSpent;
    data['current_balance'] = this.currentBalance;
    return data;
  }
}

class Transactions {
  int? currentPage;
  List<TransectionsData>? transectionsData;
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

  Transactions(
      {this.currentPage,
        this.transectionsData,
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

  Transactions.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      transectionsData = <TransectionsData>[];
      json['data'].forEach((v) {
        transectionsData!.add(new TransectionsData.fromJson(v));
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
    if (this.transectionsData != null) {
      data['data'] = this.transectionsData!.map((v) => v.toJson()).toList();
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

class TransectionsData {
  int? id;
  int? userId;
  String? activity;
  String? date;
  String? type;
  String? achievementType;
  int? coins;
  int? achivements;
  String? createdAt;
  String? updatedAt;

  TransectionsData(
      {this.id,
        this.userId,
        this.activity,
        this.date,
        this.type,
        this.coins,
        this.achivements,
        this.achievementType,
        this.createdAt,
        this.updatedAt});

  TransectionsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    activity = json['activity'];
    date = json['date'];
    type = json['type'];
    coins = json['coins'];
    achivements = json['achivements'];
    achievementType= json['achivements_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['activity'] = this.activity;
    data['date'] = this.date;
    data['type'] = this.type;
    data['coins'] = this.coins;
    data['achivements'] = this.achivements;
    data['achivements_type'] = this.achievementType;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
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
