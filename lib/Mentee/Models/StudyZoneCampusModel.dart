class StudyZoneCampusModel {
  bool? status;
  StudyZoneData? studyZoneData;

  StudyZoneCampusModel({this.status, this.studyZoneData});

  StudyZoneCampusModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    studyZoneData = json['data'] != null
        ? new StudyZoneData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.studyZoneData != null) {
      data['data'] = this.studyZoneData!.toJson();
    }
    return data;
  }
}

class StudyZoneData {
  int? currentPage;
  List<StudyZoneCampusData>? studyZoneCampusData;
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

  StudyZoneData({
    this.currentPage,
    this.studyZoneCampusData,
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

  StudyZoneData.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      studyZoneCampusData = <StudyZoneCampusData>[];
      json['data'].forEach((v) {
        studyZoneCampusData!.add(new StudyZoneCampusData.fromJson(v));
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
    if (this.studyZoneCampusData != null) {
      data['data'] = this.studyZoneCampusData!.map((v) => v.toJson()).toList();
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

class StudyZoneCampusData {
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
  Uploader? uploader;

  StudyZoneCampusData({
    this.id,
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
    this.uploader,
  });

  StudyZoneCampusData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    tag = json['tag'].cast<String>();
    filePdf = json['file_pdf'];
    description = json['description'];
    uploadedBy = json['uploaded_by'];
    downloadsCount = json['downloads_count'];
    collegeId = json['college_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
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
  bool? emailVerifiedAt;
  String? refreshToken;
  String? webFcmToken;
  String? deviceFcmToken;
  String? role;
  String? designation;
  int? exp;
  Null? bio;
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
  String? profilePicUrl;

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
    this.profilePicUrl,
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
