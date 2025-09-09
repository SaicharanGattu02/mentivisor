class ResourceDetailsModel {
  bool? status;
  String? message;
  Data? data;

  ResourceDetailsModel({this.status, this.data,this.message});

  ResourceDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? name;
  String? image;
  List<String>? tag;
  String? filePdf;
  String? description;
  int? uploadedBy;
  int? downloadsCount;
  int? collegeId;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;
  bool? isReportedStudyZone;
  Uploader? uploader;

  Data(
      {this.id,
        this.name,
        this.image,
        this.tag,
        this.filePdf,
        this.description,
        this.uploadedBy,
        this.downloadsCount,
        this.collegeId,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.isReportedStudyZone,
        this.uploader});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    if (json['tag'] != null) {
      tag = List<String>.from(json['tag']);
    } else {
      tag = []; // or null, depending on your need
    }
    filePdf = json['file_pdf'];
    description = json['description'];
    uploadedBy = json['uploaded_by'];
    downloadsCount = json['downloads_count'];
    collegeId = json['college_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    isReportedStudyZone = json['is_reported_study_zone'];
    uploader = json['uploader'] != null
        ? new Uploader.fromJson(json['uploader'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['tag'] = this.tag;
    data['file_pdf'] = this.filePdf;
    data['description'] = this.description;
    data['uploaded_by'] = this.uploadedBy;
    data['downloads_count'] = this.downloadsCount;
    data['college_id'] = this.collegeId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['is_reported_study_zone'] = this.isReportedStudyZone;
    if (this.uploader != null) {
      data['uploader'] = this.uploader!.toJson();
    }
    return data;
  }
}

class Uploader {
  int? id;
  String? name;
  String? email;
  int? contact;
  Null? emailVerifiedAt;
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
  String? profilePicUrl;

  Uploader(
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
        this.profilePicUrl});

  Uploader.fromJson(Map<String, dynamic> json) {
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
    data['profile_pic_url'] = this.profilePicUrl;
    return data;
  }
}
