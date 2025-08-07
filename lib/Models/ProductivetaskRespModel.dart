class ProductivetaskRespModel {
  bool? status;
  String? message;
  Task? task;

  ProductivetaskRespModel({this.status, this.message, this.task});

  ProductivetaskRespModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    task = json['task'] != null ? new Task.fromJson(json['task']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.task != null) {
      data['task'] = this.task!.toJson();
    }
    return data;
  }
}

class Task {
  int? userId;
  String? taskDate;
  String? title;
  String? updatedAt;
  String? createdAt;
  int? id;

  Task(
      {this.userId,
        this.taskDate,
        this.title,
        this.updatedAt,
        this.createdAt,
        this.id});

  Task.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    taskDate = json['task_date'];
    title = json['title'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['task_date'] = this.taskDate;
    data['title'] = this.title;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}
