    class MilestonesModel {
      bool? status;
      String? userId;
      String? month;
      List<Milestones>? milestones;

      MilestonesModel({this.status, this.userId, this.month, this.milestones});

      MilestonesModel.fromJson(Map<String, dynamic> json) {
        status = json['status'];
        userId = json['user_id']?.toString(); // 👈 Convert int → String
        month = json['month'];
        if (json['milestones'] != null) {
          milestones = <Milestones>[];
          json['milestones'].forEach((v) {
            milestones!.add(new Milestones.fromJson(v));
          });
        }
      }

      Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['status'] = this.status;
        data['user_id'] = this.userId;
        data['month'] = this.month;
        if (this.milestones != null) {
          data['milestones'] = this.milestones!.map((v) => v.toJson()).toList();
        }
        return data;
      }
    }

    class Milestones {
      String? type;
      int? target;
      int? completed;
      int? remaining;
      int? progressPercent;
      String? status;
      int? coinsReward;

      Milestones(
          {this.type,
            this.target,
            this.completed,
            this.remaining,
            this.progressPercent,
            this.status,
            this.coinsReward});

      Milestones.fromJson(Map<String, dynamic> json) {
        type = json['type'];
        target = json['target'];
        completed = json['completed'];
        remaining = json['remaining'];
        progressPercent = json['progress_percent'];
        status = json['status'];
        coinsReward = json['coins_reward'];
      }

      Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['type'] = this.type;
        data['target'] = this.target;
        data['completed'] = this.completed;
        data['remaining'] = this.remaining;
        data['progress_percent'] = this.progressPercent;
        data['status'] = this.status;
        data['coins_reward'] = this.coinsReward;
        return data;
      }
    }
