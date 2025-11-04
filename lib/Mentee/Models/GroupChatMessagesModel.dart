class GroupChatMessagesModel {
  bool? status;
  Message? message;

  GroupChatMessagesModel({this.status, this.message});

  GroupChatMessagesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'] != null
        ? new Message.fromJson(json['message'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.message != null) {
      data['message'] = this.message!.toJson();
    }
    return data;
  }
}

class Message {
  int? currentPage;
  List<GroupMessages>? groupMessages;
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

  Message({
    this.currentPage,
    this.groupMessages,
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
    this.total,
  });

  Message.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      groupMessages = <GroupMessages>[];
      json['data'].forEach((v) {
        groupMessages!.add(new GroupMessages.fromJson(v));
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
    if (this.groupMessages != null) {
      data['data'] = this.groupMessages!.map((v) => v.toJson()).toList();
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

class GroupMessages {
  int? id;
  int? collegeId;
  int? senderId;
  String? message;
  String? url;
  String? type;
  String? createdAt;
  String? updatedAt;
  Sender? sender;

  GroupMessages({
    this.id,
    this.collegeId,
    this.senderId,
    this.message,
    this.url,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.sender,
  });

  // 👇 ADD THIS METHOD
  GroupMessages copyWith({
    int? id,
    int? collegeId,
    int? senderId,
    String? message,
    String? url,
    String? type,
    String? createdAt,
    String? updatedAt,
    Sender? sender,
  }) {
    return GroupMessages(
      id: id ?? this.id,
      collegeId: collegeId ?? this.collegeId,
      senderId: senderId ?? this.senderId,
      message: message ?? this.message,
      url: url ?? this.url,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      sender: sender ?? this.sender,
    );
  }

  GroupMessages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    collegeId = json['college_id'];
    senderId = json['sender_id'];
    message = json['message'];
    url = json['url'];
    type = json['type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    sender = json['sender'] != null
        ? new Sender.fromJson(json['sender'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['college_id'] = this.collegeId;
    data['sender_id'] = this.senderId;
    data['message'] = this.message;
    data['url'] = this.url;
    data['type'] = this.type;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.sender != null) {
      data['sender'] = this.sender!.toJson();
    }
    return data;
  }
}

class Sender {
  int? id;
  String? name;
  String? profilePic;
  String? profilePicUrl;

  Sender({this.id, this.name, this.profilePic, this.profilePicUrl});

  Sender.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    profilePic = json['profile_pic'];
    profilePicUrl = json['profile_pic_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['profile_pic'] = this.profilePic;
    data['profile_pic_url'] = this.profilePicUrl;
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
