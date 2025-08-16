class MentorProfileModel {
  bool? status;
  MentorData? data;

  MentorProfileModel({this.status, this.data});

  MentorProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? MentorData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class MentorData {
  int? id;
  int? userId;
  String? reasonForBecomeMentor;
  String? achivements;
  String? portfolio;
  String? linkedIn;
  String? gitHub;
  String? resume;
  List<String>? languages;
  String? coinsPerMinute;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  int? activeStatus;
  String? resumeUrl;
  List<Slot>? todaySlots;
  List<Slot>? tomorrowSlots;
  int? averageRating;
  int? totalReviews;
  List<dynamic>? reviews;
  User? user;
  List<dynamic>? expertises;
  List<dynamic>? ratings;

  MentorData({
    this.id,
    this.userId,
    this.reasonForBecomeMentor,
    this.achivements,
    this.portfolio,
    this.linkedIn,
    this.gitHub,
    this.resume,
    this.languages,
    this.coinsPerMinute,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.activeStatus,
    this.resumeUrl,
    this.todaySlots,
    this.tomorrowSlots,
    this.averageRating,
    this.totalReviews,
    this.reviews,
    this.user,
    this.expertises,
    this.ratings,
  });

  MentorData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    reasonForBecomeMentor = json['reason_for_become_mentor'];
    achivements = json['achivements'];
    portfolio = json['portfolio'];
    linkedIn = json['linked_in'];
    gitHub = json['git_hub'];
    resume = json['resume'];
    languages = List<String>.from(json['langages'] ?? []);
    coinsPerMinute = json['coins_per_minute'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    activeStatus = json['active_status'];
    resumeUrl = json['resume_url'];
    todaySlots = (json['today_slots'] as List<dynamic>?)
        ?.map((e) => Slot.fromJson(e))
        .toList();
    tomorrowSlots = (json['tomorrow_slots'] as List<dynamic>?)
        ?.map((e) => Slot.fromJson(e))
        .toList();
    averageRating = json['average_rating'];
    totalReviews = json['total_reviews'];
    reviews = json['reviews'] ?? [];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    expertises = json['expertises'] ?? [];
    ratings = json['ratings'] ?? [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['user_id'] = userId;
    data['reason_for_become_mentor'] = reasonForBecomeMentor;
    data['achivements'] = achivements;
    data['portfolio'] = portfolio;
    data['linked_in'] = linkedIn;
    data['git_hub'] = gitHub;
    data['resume'] = resume;
    data['langages'] = languages;
    data['coins_per_minute'] = coinsPerMinute;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['active_status'] = activeStatus;
    data['resume_url'] = resumeUrl;
    data['today_slots'] = todaySlots?.map((e) => e.toJson()).toList();
    data['tomorrow_slots'] = tomorrowSlots?.map((e) => e.toJson()).toList();
    data['average_rating'] = averageRating;
    data['total_reviews'] = totalReviews;
    data['reviews'] = reviews;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['expertises'] = expertises;
    data['ratings'] = ratings;
    return data;
  }
}

class Slot {
  int? id;
  String? date;
  String? startTime;
  String? endTime;
  String? status;

  Slot({this.id, this.date, this.startTime, this.endTime, this.status});

  Slot.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['date'] = date;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['status'] = status;
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
  int? emailOtp;
  String? expiredTime;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  int? activeStatus;
  String? lastLoginAt;
  String? profilePicUrl;
  String? mentorStatus; // <-- new field

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
    this.profilePicUrl,
    this.mentorStatus,
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
    profilePicUrl = json['profile_pic_url'];
    mentorStatus = json['mentor_status'];
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
    data['last_login_at'] = lastLoginAt;
    data['profile_pic_url'] = profilePicUrl;
    data['mentor_status'] = mentorStatus;
    return data;
  }
}
