class NotificationModel {
  bool? status;
  String? message;
  Notify? notify;
  int? currentPage;
  int? lastPage;
  int? total;

  NotificationModel({
    this.status,
    this.message,
    this.notify,
    this.currentPage,
    this.lastPage,
    this.total,
  });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    notify = json['data'] != null ? Notify.fromJson(json['data']) : null;
    currentPage = json['currentPage'];
    lastPage = json['lastPage'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (notify != null) map['data'] = notify!.toJson();
    map['currentPage'] = currentPage;
    map['lastPage'] = lastPage;
    map['total'] = total;
    return map;
  }
}

class Notify {
  int? currentPage;
  List<Data>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Links>? links;
  dynamic nextPageUrl;
  String? path;
  dynamic perPage;
  dynamic prevPageUrl;
  int? to;
  int? total;

  Notify({
    this.currentPage,
    this.data,
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

  Notify.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
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
    final map = <String, dynamic>{};
    map['current_page'] = currentPage;
    if (data != null) map['data'] = data!.map((v) => v.toJson()).toList();
    map['first_page_url'] = firstPageUrl;
    map['from'] = from;
    map['last_page'] = lastPage;
    map['last_page_url'] = lastPageUrl;
    if (links != null) map['links'] = links!.map((v) => v.toJson()).toList();
    map['next_page_url'] = nextPageUrl;
    map['path'] = path;
    map['per_page'] = perPage;
    map['prev_page_url'] = prevPageUrl;
    map['to'] = to;
    map['total'] = total;
    return map;
  }
}

class Data {
  int? id;
  int? userId;
  String? type;
  String? title;
  String? remarks;
  String? message;
  int? isRead;
  String? role;
  String? createdAt;
  String? updatedAt;
  User? user;

  Data({
    this.id,
    this.userId,
    this.type,
    this.title,
    this.remarks,
    this.message,
    this.isRead,
    this.role,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    type = json['type'];
    title = json['title'];
    remarks = json['remarks'];
    message = json['message'];
    isRead = json['is_read'];
    role = json['role'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['userId'] = userId;
    map['type'] = type;
    map['title'] = title;
    map['remarks'] = remarks;
    map['message'] = message;
    map['is_read'] = isRead;
    map['role'] = role;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    if (user != null) map['user'] = user!.toJson();
    return map;
  }
}

class User {
  int? id;
  String? name;
  String? email;
  int? contact;
  dynamic emailVerifiedAt;
  String? refreshToken;
  dynamic webFcmToken;
  String? deviceFcmToken;
  String? role;
  dynamic designation;
  dynamic exp;
  String? bio;
  int? collegeId;
  String? year;
  String? stream;
  dynamic gender;
  String? status;
  String? profilePic;
  dynamic state;
  dynamic city;
  dynamic country;
  String? saasId;
  dynamic emailOtp;
  dynamic expiredTime;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  int? activeStatus;
  String? lastLoginAt;
  String? mentorStatus;
  dynamic topMentorRank;
  String? profilePicUrl;

  User({
    this.id,
    this.name,
    this.email,
    this.contact,
    this.emailVerifiedAt,
    this.refreshToken,
    this.webFcmToken,
    this.deviceFcmToken,
    this.role,
    this.designation,
    this.exp,
    this.bio,
    this.collegeId,
    this.year,
    this.stream,
    this.gender,
    this.status,
    this.profilePic,
    this.state,
    this.city,
    this.country,
    this.saasId,
    this.emailOtp,
    this.expiredTime,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.activeStatus,
    this.lastLoginAt,
    this.mentorStatus,
    this.topMentorRank,
    this.profilePicUrl,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    contact = json['contact'];
    emailVerifiedAt = json['email_verified_at'];
    refreshToken = json['refresh_token'];
    webFcmToken = json['web_fcm_token'];
    deviceFcmToken = json['device_fcm_token'];
    role = json['role'];
    designation = json['designation'];
    exp = json['exp'];
    bio = json['bio'];
    collegeId = json['college_id'];
    year = json['year'];
    stream = json['stream'];
    gender = json['gender'];
    status = json['status'];
    profilePic = json['profile_pic'];
    state = json['state'];
    city = json['city'];
    country = json['country'];
    saasId = json['saas_id'];
    emailOtp = json['email_otp'];
    expiredTime = json['expired_time'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    activeStatus = json['active_status'];
    lastLoginAt = json['last_login_at'];
    mentorStatus = json['mentor_status'];
    topMentorRank = json['top_mentor_rank'];
    profilePicUrl = json['profile_pic_url'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['email'] = email;
    map['contact'] = contact;
    map['email_verified_at'] = emailVerifiedAt;
    map['refresh_token'] = refreshToken;
    map['web_fcm_token'] = webFcmToken;
    map['device_fcm_token'] = deviceFcmToken;
    map['role'] = role;
    map['designation'] = designation;
    map['exp'] = exp;
    map['bio'] = bio;
    map['college_id'] = collegeId;
    map['year'] = year;
    map['stream'] = stream;
    map['gender'] = gender;
    map['status'] = status;
    map['profile_pic'] = profilePic;
    map['state'] = state;
    map['city'] = city;
    map['country'] = country;
    map['saas_id'] = saasId;
    map['email_otp'] = emailOtp;
    map['expired_time'] = expiredTime;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['deleted_at'] = deletedAt;
    map['active_status'] = activeStatus;
    map['last_login_at'] = lastLoginAt;
    map['mentor_status'] = mentorStatus;
    map['top_mentor_rank'] = topMentorRank;
    map['profile_pic_url'] = profilePicUrl;
    return map;
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
    final map = <String, dynamic>{};
    map['url'] = url;
    map['label'] = label;
    map['active'] = active;
    return map;
  }
}
