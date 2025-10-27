class CompusMentorListModel {
  bool? status;
  Data? data;

  CompusMentorListModel({this.status, this.data});

  CompusMentorListModel.fromJson(Map<String, dynamic> json) {
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
  List<MentorsList>? mentors_list;
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

  Data({
    this.currentPage,
    this.mentors_list,
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

  Data.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      mentors_list = <MentorsList>[];
      json['data'].forEach((v) {
        mentors_list!.add(new MentorsList.fromJson(v));
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
    if (this.mentors_list != null) {
      data['data'] = this.mentors_list!.map((v) => v.toJson()).toList();
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

class MentorsList {
  int? id;
  int? userId;
  String? reasonForBecomeMentor;
  String? achivements;
  String? portfolio;
  String? linkedIn;
  String? gitHub;
  String? resume;
  List<String>? langages;
  String? coinsPerMinute;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  int? activeStatus;
  String? resumeUrl;
  List<Slot>? todaySlots;
  List<Slot>? tomorrowSlots;
  List<Expertise>? expertises;
  dynamic averageRating;
  dynamic totalReviews;
  User? user;

  MentorsList({
    this.id,
    this.userId,
    this.reasonForBecomeMentor,
    this.achivements,
    this.portfolio,
    this.linkedIn,
    this.gitHub,
    this.resume,
    this.langages,
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
    this.user,
    this.expertises,
  });

  MentorsList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    reasonForBecomeMentor = json['reason_for_become_mentor'];
    achivements = json['achivements'];
    portfolio = json['portfolio'];
    linkedIn = json['linked_in'];
    gitHub = json['git_hub'];
    resume = json['resume'];
    coinsPerMinute = json['coins_per_minute'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    activeStatus = json['active_status'];
    resumeUrl = json['resume_url'];
    averageRating = json['average_rating'];
    totalReviews = json['total_reviews'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    if (json['today_slots'] != null) {
      todaySlots = <Slot>[];
      json['today_slots'].forEach((v) {
        todaySlots!.add(Slot.fromJson(v));
      });
    }

    if (json['tomorrow_slots'] != null) {
      tomorrowSlots = <Slot>[];
      json['tomorrow_slots'].forEach((v) {
        tomorrowSlots!.add(Slot.fromJson(v));
      });
    }

    if (json['expertises'] != null) {
      expertises = <Expertise>[];
      json['expertises'].forEach((v) {
        expertises!.add(Expertise.fromJson(v));
      });
    }
    if (json['langages'] != null && json['langages'] is List) {
      langages = List<String>.from(json['langages']);
    } else {
      langages = [];
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['reason_for_become_mentor'] = this.reasonForBecomeMentor;
    data['achivements'] = this.achivements;
    data['portfolio'] = this.portfolio;
    data['linked_in'] = this.linkedIn;
    data['git_hub'] = this.gitHub;
    data['resume'] = this.resume;
    data['langages'] = this.langages;
    data['coins_per_minute'] = this.coinsPerMinute;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['active_status'] = this.activeStatus;
    data['resume_url'] = this.resumeUrl;
    data['average_rating'] = this.averageRating;
    data['total_reviews'] = this.totalReviews;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.todaySlots != null) {
      data['today_slots'] = this.todaySlots!.map((v) => v.toJson()).toList();
    }
    if (this.tomorrowSlots != null) {
      data['tomorrow_slots'] = this.tomorrowSlots!.map((v) => v.toJson()).toList();
    }
    if (this.expertises != null) {
      data['expertises'] = this.expertises!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class Slot {
  int? id;
  String? date;
  String? status;
  String? startTime;
  String? endTime;

  Slot({this.id, this.date, this.status, this.startTime, this.endTime});

  Slot.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    status = json['status'];
    startTime = json['start_time'];
    endTime = json['end_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = this.id;
    data['date'] = this.date;
    data['status'] = this.status;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    return data;
  }
}


class Expertise {
  int? id;
  String? name;
  int? baseValue;

  Expertise({this.id, this.name, this.baseValue});

  Expertise.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    baseValue = json['base_value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = this.id;
    data['name'] = this.name;
    data['base_value'] = this.baseValue;
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
  String? mentorStatus;
  String? profilePicUrl;
  College? college;
  int? topMentorRank;

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
    this.profilePicUrl,
    this.college,
    this.topMentorRank,
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
    profilePicUrl = json['profile_pic_url'];
    topMentorRank = json['top_mentor_rank'];
    college = json['college'] != null
        ? new College.fromJson(json['college'])
        : null;
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
    data['top_mentor_rank'] = this.topMentorRank;
    if (this.college != null) {
      data['college'] = this.college!.toJson();
    }
    return data;
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
  String? deletedAt;
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
    name = json['Name'];
    state = json['State'];
    city = json['City'];
    dist = json['Dist'];
    pincode = json['pincode'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    activeStatus = json['active_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['Name'] = this.name;
    data['State'] = this.state;
    data['City'] = this.city;
    data['Dist'] = this.dist;
    data['pincode'] = this.pincode;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['active_status'] = this.activeStatus;
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
