class TaskStatesModel {
  bool? status;
  int? currentStreak;
  int? completedTask;
  int? todayTask;

  TaskStatesModel(
      {this.status, this.currentStreak, this.completedTask, this.todayTask});

  TaskStatesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    currentStreak = json['current_streak'];
    completedTask = json['completed_task'];
    todayTask = json['today_task'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['current_streak'] = this.currentStreak;
    data['completed_task'] = this.completedTask;
    data['today_task'] = this.todayTask;
    return data;
  }
}
