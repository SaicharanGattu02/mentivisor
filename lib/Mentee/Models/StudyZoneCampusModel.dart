class StudyZoneCampusModel {
  bool? status;
  StudyZoneData? studyZoneData;

  StudyZoneCampusModel({this.status, this.studyZoneData});

  StudyZoneCampusModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    studyZoneData =
    json['data'] != null ? StudyZoneData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    if (studyZoneData != null) {
      data['data'] = studyZoneData!.toJson();
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
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
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
        studyZoneCampusData!.add(StudyZoneCampusData.fromJson(v));
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
    if (studyZoneCampusData != null) {
      data['data'] = studyZoneCampusData!.map((v) => v.toJson()).toList();
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
  String? deletedAt;
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
    tag = json['tag'] != null ? List<String>.from(json['tag']) : [];
    filePdf = json['file_pdf'];
    description = json['description'];
    uploadedBy = json['uploaded_by'];
    downloadsCount = json['downloads_count'];
    collegeId = json['college_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    uploader =
    json['uploader'] != null ? Uploader.fromJson(json['uploader']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['tag'] = tag;
    data['file_pdf'] = filePdf;
    data['description'] = description;
    data['uploaded_by'] = uploadedBy;
    data['downloads_count'] = downloadsCount;
    data['college_id'] = collegeId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    if (uploader != null) {
      data['uploader'] = uploader!.toJson();
    }
    return data;
  }
}

class Uploader {
  int? id;
  String? name;
  String? email;
  String? contact;
  String? emailVerifiedAt;
  String? refreshToken;
  String? webFcmToken;
  String? deviceFcmToken;
  String? role;
  String? designation;
  int? exp;
  String? bio;
  int? collegeId;
  String? year;
  String? stream;
  String? gender;
  String? status;
  String? profilePic;
  String? state;
  String? city;
  String? country;
  String? saasId;
  String? emailOtp;
  String? expiredTime;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  int? activeStatus;

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
  });

  Uploader.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    contact = json['contact']?.toString();
    emailVerifiedAt = json['email_verified_at']?.toString();
    refreshToken = json['refresh_token'];
    webFcmToken = json['web_fcm_token'];
    deviceFcmToken = json['device_fcm_token'];
    role = json['role'];
    designation = json['designation'];
    exp = json['exp'];
    bio = json['bio']?.toString();
    collegeId = json['college_id'];
    year = json['year'];
    stream = json['stream'];
    gender = json['gender']?.toString();
    status = json['status'];
    profilePic = json['profile_pic'];
    state = json['state']?.toString();
    city = json['city']?.toString();
    country = json['country']?.toString();
    saasId = json['saas_id'];
    emailOtp = json['email_otp']?.toString();
    expiredTime = json['expired_time']?.toString();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at']?.toString();
    activeStatus = json['active_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['contact'] = contact;
    data['email_verified_at'] = emailVerifiedAt;
    data['refresh_token'] = refreshToken;
    data['web_fcm_token'] = webFcmToken;
    data['device_fcm_token'] = deviceFcmToken;
    data['role'] = role;
    data['designation'] = designation;
    data['exp'] = exp;
    data['bio'] = bio;
    data['college_id'] = collegeId;
    data['year'] = year;
    data['stream'] = stream;
    data['gender'] = gender;
    data['status'] = status;
    data['profile_pic'] = profilePic;
    data['state'] = state;
    data['city'] = city;
    data['country'] = country;
    data['saas_id'] = saasId;
    data['email_otp'] = emailOtp;
    data['expired_time'] = expiredTime;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['active_status'] = activeStatus;
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
