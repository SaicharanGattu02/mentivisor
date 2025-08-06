class MentorProfileModel {
  bool? status;
  Data? data;

  MentorProfileModel({this.status, this.data});

  MentorProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  int? userId;
  String? reasonForBecomeMentor;
  String? achivements;
  String? portfolio;
  String? linkedIn;
  String? gitHub;
  String? resume;
  List<String>? languages;  // Corrected 'langages' to 'languages'
  String? coinsPerMinute;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;  // Replaced with String as 'Null' is not appropriate here
  int? activeStatus;
  String? resumeUrl;
  List<String>? todaySlots;  // Replaced 'Null' with String or other relevant type
  List<String>? tomorrowSlots;  // Replaced 'Null' with String or other relevant type
  int? averageRating;
  int? totalReviews;
  List<String>? reviews;  // Replaced 'Null' with String or other relevant type
  User? user;
  List<String>? expertises;  // Replaced 'Null' with String or other relevant type
  List<String>? ratings;  // Replaced 'Null' with String or other relevant type

  Data({
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

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    reasonForBecomeMentor = json['reason_for_become_mentor'];
    achivements = json['achivements'];
    portfolio = json['portfolio'];
    linkedIn = json['linked_in'];
    gitHub = json['git_hub'];
    resume = json['resume'];
    languages = List<String>.from(json['langages'] ?? []);  // Corrected to handle languages properly
    coinsPerMinute = json['coins_per_minute'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    activeStatus = json['active_status'];
    resumeUrl = json['resume_url'];
    todaySlots = List<String>.from(json['today_slots'] ?? []);  // Handle slots properly
    tomorrowSlots = List<String>.from(json['tomorrow_slots'] ?? []);  // Handle slots properly
    averageRating = json['average_rating'];
    totalReviews = json['total_reviews'];
    reviews = List<String>.from(json['reviews'] ?? []);  // Handle reviews properly
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    expertises = List<String>.from(json['expertises'] ?? []);  // Handle expertises properly
    ratings = List<String>.from(json['ratings'] ?? []);  // Handle ratings properly
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['reason_for_become_mentor'] = this.reasonForBecomeMentor;
    data['achivements'] = this.achivements;
    data['portfolio'] = this.portfolio;
    data['linked_in'] = this.linkedIn;
    data['git_hub'] = this.gitHub;
    data['resume'] = this.resume;
    data['langages'] = this.languages;
    data['coins_per_minute'] = this.coinsPerMinute;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['active_status'] = this.activeStatus;
    data['resume_url'] = this.resumeUrl;
    data['today_slots'] = this.todaySlots;
    data['tomorrow_slots'] = this.tomorrowSlots;
    data['average_rating'] = this.averageRating;
    data['total_reviews'] = this.totalReviews;
    data['reviews'] = this.reviews;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['expertises'] = this.expertises;
    data['ratings'] = this.ratings;
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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
