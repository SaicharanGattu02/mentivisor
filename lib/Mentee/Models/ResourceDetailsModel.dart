class ResourceDetailsModel {
  bool? status;
  String? message;
  ResourceData? data;

  ResourceDetailsModel({this.status, this.message, this.data});

  ResourceDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? ResourceData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (data != null) map['data'] = data!.toJson();
    return map;
  }
}

class ResourceData {
  int? id;
  String? name;
  String? image;
  List<String>? tag;
  String? filePdf;
  String? description;
  int? uploadedBy;
  int? downloadsCount;
  String? active;
  int? collegeId;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  bool? isReportedStudyZone;
  Uploader? uploader;

  ResourceData({
    this.id,
    this.name,
    this.image,
    this.tag,
    this.filePdf,
    this.description,
    this.uploadedBy,
    this.downloadsCount,
    this.active,
    this.collegeId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.isReportedStudyZone,
    this.uploader,
  });

  ResourceData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    if (json['tag'] is List) {
      tag = List<String>.from(json['tag'].map((e) => e.toString()));
    } else {
      tag = [];
    }
    filePdf = json['file_pdf'];
    description = json['description'];
    uploadedBy = json['uploaded_by'];
    downloadsCount = json['downloads_count'];
    active = json['active'];
    collegeId = json['college_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at']; // can be null or string
    isReportedStudyZone = json['is_reported_study_zone'];
    uploader =
    json['uploader'] != null ? Uploader.fromJson(json['uploader']) : null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['image'] = image;
    map['tag'] = tag;
    map['file_pdf'] = filePdf;
    map['description'] = description;
    map['uploaded_by'] = uploadedBy;
    map['downloads_count'] = downloadsCount;
    map['active'] = active;
    map['college_id'] = collegeId;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['deleted_at'] = deletedAt;
    map['is_reported_study_zone'] = isReportedStudyZone;
    if (uploader != null) map['uploader'] = uploader!.toJson();
    return map;
  }
}

class Uploader {
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
  College? college;
  YearRelation? yearRelation;

  Uploader({
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
    this.college,
    this.yearRelation,
  });

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
    topMentorRank = json['top_mentor_rank'];
    profilePicUrl = json['profile_pic_url'];
    college =
    json['college'] != null ? College.fromJson(json['college']) : null;
    yearRelation = json['year_relation'] != null
        ? YearRelation.fromJson(json['year_relation'])
        : null;
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
    if (college != null) map['college'] = college!.toJson();
    if (yearRelation != null) map['year_relation'] = yearRelation!.toJson();
    return map;
  }
}

class College {
  int? id;
  String? name;
  String? state;
  String? city;
  String? dist;
  String? pincode;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  int? activeStatus;

  College({
    this.id,
    this.name,
    this.state,
    this.city,
    this.dist,
    this.pincode,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.activeStatus,
  });

  College.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['Name'] ?? json['name'];
    state = json['State'] ?? json['state'];
    city = json['City'] ?? json['city'];
    dist = json['Dist'] ?? json['dist'];
    pincode = json['pincode'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    activeStatus = json['active_status'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['Name'] = name;
    map['State'] = state;
    map['City'] = city;
    map['Dist'] = dist;
    map['pincode'] = pincode;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['deleted_at'] = deletedAt;
    map['active_status'] = activeStatus;
    return map;
  }
}

class YearRelation {
  int? id;
  String? name;
  String? createdAt;
  dynamic updatedAt;
  dynamic deletedAt;
  int? activeStatus;

  YearRelation({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.activeStatus,
  });

  YearRelation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    activeStatus = json['active_status'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['deleted_at'] = deletedAt;
    map['active_status'] = activeStatus;
    return map;
  }
}
