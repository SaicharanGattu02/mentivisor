class SelectSlotModel {
  bool? status;
  Slot? slot;
  Wallet? wallet;

  SelectSlotModel({this.status, this.slot, this.wallet});

  SelectSlotModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    slot = json['slot'] != null ? new Slot.fromJson(json['slot']) : null;
    wallet =
    json['wallet'] != null ? new Wallet.fromJson(json['wallet']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.slot != null) {
      data['slot'] = this.slot!.toJson();
    }
    if (this.wallet != null) {
      data['wallet'] = this.wallet!.toJson();
    }
    return data;
  }
}

class Slot {
  int? id;
  String? date;
  String? timeLabel;
  int? durationMinutes;
  int? sessionCost;
  bool? isBooked;

  Slot(
      {this.id,
        this.date,
        this.timeLabel,
        this.durationMinutes,
        this.sessionCost,
        this.isBooked});

  Slot.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    timeLabel = json['time_label'];
    durationMinutes = json['duration_minutes'];
    sessionCost = json['session_cost'];
    isBooked = json['is_booked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['time_label'] = this.timeLabel;
    data['duration_minutes'] = this.durationMinutes;
    data['session_cost'] = this.sessionCost;
    data['is_booked'] = this.isBooked;
    return data;
  }
}

class Wallet {
  int? availableCoins;
  int? sessionCoins;
  int? balanceCoins;
  bool? enoughBalance;

  Wallet(
      {this.availableCoins,
        this.sessionCoins,
        this.balanceCoins,
        this.enoughBalance});

  Wallet.fromJson(Map<String, dynamic> json) {
    availableCoins = json['available_coins'];
    sessionCoins = json['session_coins'];
    balanceCoins = json['balance_coins'];
    enoughBalance = json['enough_balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['available_coins'] = this.availableCoins;
    data['session_coins'] = this.sessionCoins;
    data['balance_coins'] = this.balanceCoins;
    data['enough_balance'] = this.enoughBalance;
    return data;
  }
}
