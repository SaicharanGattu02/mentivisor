class CommonProfileModel {
  bool? status;
  User? user;

  CommonProfileModel({this.status, this.user});

  CommonProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? email;
  int? contact;
  String? emailVerifiedAt;
  String? refreshToken;
  String? webFcmToken;
  String? deviceFcmToken;
  String? role;
  Null? designation;
  Null? exp;
  String? bio;
  int? collegeId;
  String? year;
  String? stream;
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
  String? lastLoginAt;
  String? mentorStatus;
  Null? topMentorRank;
  String? profilePicUrl;

  User(
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
        this.lastLoginAt,
        this.mentorStatus,
        this.topMentorRank,
        this.profilePicUrl});

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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['contact'] = this.contact;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['refresh_token'] = this.refreshToken;
    data['web_fcm_token'] = this.webFcmToken;
    data['device_fcm_token'] = this.deviceFcmToken;
    data['role'] = this.role;
    data['designation'] = this.designation;
    data['exp'] = this.exp;
    data['bio'] = this.bio;
    data['college_id'] = this.collegeId;
    data['year'] = this.year;
    data['stream'] = this.stream;
    data['gender'] = this.gender;
    data['status'] = this.status;
    data['profile_pic'] = this.profilePic;
    data['state'] = this.state;
    data['city'] = this.city;
    data['country'] = this.country;
    data['saas_id'] = this.saasId;
    data['email_otp'] = this.emailOtp;
    data['expired_time'] = this.expiredTime;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['active_status'] = this.activeStatus;
    data['last_login_at'] = this.lastLoginAt;
    data['mentor_status'] = this.mentorStatus;
    data['top_mentor_rank'] = this.topMentorRank;
    data['profile_pic_url'] = this.profilePicUrl;
    return data;
  }
}
