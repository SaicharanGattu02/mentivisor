class GuestMentorsModel {
  bool? status;
  MentorData? data;

  GuestMentorsModel({this.status, this.data});

  GuestMentorsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? MentorData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['status'] = status;
    if (data != null) map['data'] = data!.toJson();
    return map;
  }
}

class MentorData {
  int? currentPage;
  List<Mentor>? mentors;
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

  MentorData({
    this.currentPage,
    this.mentors,
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

  MentorData.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      mentors = <Mentor>[];
      json['data'].forEach((v) {
        mentors!.add(Mentor.fromJson(v));
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
    final Map<String, dynamic> map = {};
    map['current_page'] = currentPage;
    if (mentors != null) {
      map['data'] = mentors!.map((v) => v.toJson()).toList();
    }
    map['first_page_url'] = firstPageUrl;
    map['from'] = from;
    map['last_page'] = lastPage;
    map['last_page_url'] = lastPageUrl;
    if (links != null) {
      map['links'] = links!.map((v) => v.toJson()).toList();
    }
    map['next_page_url'] = nextPageUrl;
    map['path'] = path;
    map['per_page'] = perPage;
    map['prev_page_url'] = prevPageUrl;
    map['to'] = to;
    map['total'] = total;
    return map;
  }
}

class Mentor {
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
  String? mentorStatus;
  int? ratingsReceivedCount;
  double? ratingsReceivedAvgRating;
  List<Slot>? slots;
  String? profilePicUrl;
  String? costPerMinute;

  Mentor({
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
    this.ratingsReceivedCount,
    this.ratingsReceivedAvgRating,
    this.slots,
    this.profilePicUrl,
    this.costPerMinute,
  });

  Mentor.fromJson(Map<String, dynamic> json) {
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
    costPerMinute = json['coins_per_minute'];
    mentorStatus = json['mentor_status'];
    ratingsReceivedCount = json['ratings_received_count'];
    ratingsReceivedAvgRating = json['ratings_received_avg_rating'] != null
        ? json['ratings_received_avg_rating'].toDouble()
        : null;
    if (json['slots'] != null) {
      slots = <Slot>[];
      json['slots'].forEach((v) {
        slots!.add(Slot.fromJson(v));
      });
    }
    profilePicUrl = json['profile_pic_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
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
    map['coins_per_minute'] = costPerMinute;
    map['active_status'] = activeStatus;
    map['last_login_at'] = lastLoginAt;
    map['mentor_status'] = mentorStatus;
    map['ratings_received_count'] = ratingsReceivedCount;
    map['ratings_received_avg_rating'] = ratingsReceivedAvgRating;
    if (slots != null) {
      map['slots'] = slots!.map((v) => v.toJson()).toList();
    }
    map['profile_pic_url'] = profilePicUrl;
    return map;
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
    final Map<String, dynamic> map = {};
    map['id'] = id;
    map['date'] = date;
    map['start_time'] = startTime;
    map['end_time'] = endTime;
    map['status'] = status;
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
    final Map<String, dynamic> map = {};
    map['url'] = url;
    map['label'] = label;
    map['active'] = active;
    return map;
  }
}
