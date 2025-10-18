class ChatMessagesModel {
  bool? status;
  Message? message;
  ReceiverDetails? receiverDetails;

  ChatMessagesModel({this.status, this.message, this.receiverDetails});

  ChatMessagesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'] != null ? Message.fromJson(json['message']) : null;
    receiverDetails = json['reciever_details'] != null
        ? ReceiverDetails.fromJson(json['reciever_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    if (message != null) data['message'] = message!.toJson();
    if (receiverDetails != null) {
      data['reciever_details'] = receiverDetails!.toJson();
    }
    return data;
  }
}

class Message {
  int? currentPage;
  List<Messages>? messages;
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
    this.messages,
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
      messages = <Messages>[];
      json['data'].forEach((v) {
        messages!.add(Messages.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(Links.fromJson(v));
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
    final Map<String, dynamic> data = {};
    data['current_page'] = currentPage;
    if (messages != null) {
      data['data'] = messages!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = firstPageUrl;
    data['from'] = from;
    data['last_page'] = lastPage;
    data['last_page_url'] = lastPageUrl;
    if (links != null) {
      data['links'] = links!.map((v) => v.toJson()).toList();
    }
    data['next_page_url'] = nextPageUrl;
    data['path'] = path;
    data['per_page'] = perPage;
    data['prev_page_url'] = prevPageUrl;
    data['to'] = to;
    data['total'] = total;
    return data;
  }
}

class Messages {
  int? id;
  int? senderId;
  int? receiverId;
  int? sessionId;
  String? message;
  String? url;
  String? createdAt;
  String? updatedAt;
  String? type;
  Sender? sender;
  Sender? receiver;

  Messages({
    this.id,
    this.senderId,
    this.receiverId,
    this.sessionId,
    this.message,
    this.url,
    this.createdAt,
    this.updatedAt,
    this.type,
    this.sender,
    this.receiver,
  });

  Messages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    senderId = json['sender_id'];
    receiverId = json['receiver_id'];
    sessionId = json['session_id']; // ✅ corrected key (was sessionId before)
    message = json['message'];
    url = json['url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    type = json['type'];
    sender = json['sender'] != null ? Sender.fromJson(json['sender']) : null;
    receiver =
    json['receiver'] != null ? Sender.fromJson(json['receiver']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['sender_id'] = senderId;
    data['receiver_id'] = receiverId;
    data['session_id'] = sessionId;
    data['message'] = message;
    data['url'] = url;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['type'] = type;
    if (sender != null) data['sender'] = sender!.toJson();
    if (receiver != null) data['receiver'] = receiver!.toJson();
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
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['profile_pic'] = profilePic;
    data['profile_pic_url'] = profilePicUrl;
    return data;
  }
}

class ReceiverDetails {
  int? id;
  String? name;
  String? profilePic;
  String? profilePicUrl;

  ReceiverDetails({this.id, this.name, this.profilePic, this.profilePicUrl});

  ReceiverDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    profilePic = json['profile_pic'];
    profilePicUrl = json['profile_pic_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['profile_pic'] = profilePic;
    data['profile_pic_url'] = profilePicUrl;
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
    final Map<String, dynamic> data = {};
    data['url'] = url;
    data['label'] = label;
    data['active'] = active;
    return data;
  }
}
