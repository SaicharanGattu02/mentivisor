class ProductToolTaskByDateModel {
  bool? status;
  List<Tasks>? tasks;

  ProductToolTaskByDateModel({this.status, this.tasks});

  ProductToolTaskByDateModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['tasks'] != null) {
      tasks = <Tasks>[];
      json['tasks'].forEach((v) {
        tasks!.add(new Tasks.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.tasks != null) {
      data['tasks'] = this.tasks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Tasks {
  int? id;
  int? userId;
  String? taskDate;
  String? taskTime;
  String? title;
  int? isCompleted;
  String? createdAt;
  String? updatedAt;

  Tasks(
      {this.id,
        this.userId,
        this.taskDate,
        this.taskTime,
        this.title,
        this.isCompleted,
        this.createdAt,
        this.updatedAt});

  Tasks.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    taskDate = json['task_date'];
    taskTime = json['task_time'];
    title = json['title'];
    isCompleted = json['is_completed'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['task_date'] = this.taskDate;
    data['task_time'] = this.taskTime;
    data['title'] = this.title;
    data['is_completed'] = this.isCompleted;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
