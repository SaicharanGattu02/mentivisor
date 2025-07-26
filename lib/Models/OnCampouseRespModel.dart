class MentorOnCamposeRespModel {
  bool? status;
  Data? data;

  MentorOnCamposeRespModel({this.status, this.data});

  MentorOnCamposeRespModel.fromJson(Map<String, dynamic> json) {
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
  int? currentPage;
  List<Compose>? compose;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Links>? links;
  Null? nextPageUrl;
  String? path;
  int? perPage;
  Null? prevPageUrl;
  int? to;
  int? total;

  Data(
      {this.currentPage,
        this.compose,
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

  Data.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      compose = <Compose>[];
      json['data'].forEach((v) {
        compose!.add(new Compose.fromJson(v));
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
    if (this.compose != null) {
      data['data'] = this.compose!.map((v) => v.toJson()).toList();
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

class Compose {
  int? id;
  String? name;
  String? email;
  int? contact;
  Null? emailVerifiedAt;
  Null? refreshToken;
  Null? webFcmToken;
  String? deviceFcmToken;
  String? role;
  Null? designation;
  Null? exp;
  String? bio;
  int? collegeId;
  String? year;
  Null? stream;
  Null? gender;
  String? status;
  String? profilePic;
  Null? state;
  Null? city;
  Null? country;
  String? saasId;
  Null? emailOtp;
  Null? expiredTime;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;
  int? activeStatus;
  int? ratingsReceivedCount;
  int? ratingsReceivedAvgRating;
  String? profilePicUrl;
  Null? mentorProfile;

  Compose(
      {this.id,
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
        this.ratingsReceivedCount,
        this.ratingsReceivedAvgRating,
        this.profilePicUrl,
        this.mentorProfile});

  Compose.fromJson(Map<String, dynamic> json) {
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
    ratingsReceivedCount = json['ratings_received_count'];
    ratingsReceivedAvgRating = json['ratings_received_avg_rating'];
    profilePicUrl = json['profile_pic_url'];
    mentorProfile = json['mentor_profile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> compose = new Map<String, dynamic>();
    compose['id'] = this.id;
    compose['name'] = this.name;
    compose['email'] = this.email;
    compose['contact'] = this.contact;
    compose['email_verified_at'] = this.emailVerifiedAt;
    compose['refresh_token'] = this.refreshToken;
    compose['web_fcm_token'] = this.webFcmToken;
    compose['device_fcm_token'] = this.deviceFcmToken;
    compose['role'] = this.role;
    compose['designation'] = this.designation;
    compose['exp'] = this.exp;
    compose['bio'] = this.bio;
    compose['college_id'] = this.collegeId;
    compose['year'] = this.year;
    compose['stream'] = this.stream;
    compose['gender'] = this.gender;
    compose['status'] = this.status;
    compose['profile_pic'] = this.profilePic;
    compose['state'] = this.state;
    compose['city'] = this.city;
    compose['country'] = this.country;
    compose['saas_id'] = this.saasId;
    compose['email_otp'] = this.emailOtp;
    compose['expired_time'] = this.expiredTime;
    compose['created_at'] = this.createdAt;
    compose['updated_at'] = this.updatedAt;
    compose['deleted_at'] = this.deletedAt;
    compose['active_status'] = this.activeStatus;
    compose['ratings_received_count'] = this.ratingsReceivedCount;
    compose['ratings_received_avg_rating'] = this.ratingsReceivedAvgRating;
    compose['profile_pic_url'] = this.profilePicUrl;
    compose['mentor_profile'] = this.mentorProfile;
    return compose;
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
    final Map<String, dynamic> compose = new Map<String, dynamic>();
    compose['url'] = this.url;
    compose['label'] = this.label;
    compose['active'] = this.active;
    return compose;
  }
}
