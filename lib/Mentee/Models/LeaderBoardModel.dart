class LeaderBoardModel {
  bool? status;
  String? month;
  List<Leaderboard>? leaderboard;

  LeaderBoardModel({this.status, this.month, this.leaderboard});

  LeaderBoardModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    month = json['month'];
    if (json['leaderboard'] != null) {
      leaderboard = <Leaderboard>[];
      json['leaderboard'].forEach((v) {
        leaderboard!.add(new Leaderboard.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['month'] = this.month;
    if (this.leaderboard != null) {
      data['leaderboard'] = this.leaderboard!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Leaderboard {
  int? rank;
  int? userId;
  String? name;
  String? image;
  dynamic achievementTypes;
  dynamic avgCompletionDays;
  dynamic score;

  Leaderboard({
    this.rank,
    this.userId,
    this.name,
    this.image,
    this.achievementTypes,
    this.avgCompletionDays,
    this.score,
  });

  Leaderboard.fromJson(Map<String, dynamic> json) {
    rank = json['rank'];
    userId = json['user_id'];
    name = json['name'];
    image = json['image'];
    achievementTypes = json['achievement_types'];
    avgCompletionDays = json['avg_completion_days'];
    score = json['score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rank'] = this.rank;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['image'] = this.image;
    data['achievement_types'] = this.achievementTypes;
    data['avg_completion_days'] = this.avgCompletionDays;
    data['score'] = this.score;
    return data;
  }
}
