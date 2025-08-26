class MentorProfileModel {
  bool? status;
  MentorData? data;

  MentorProfileModel({this.status, this.data});

  MentorProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? MentorData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['status'] = status;
    if (data != null) {
      map['data'] = data!.toJson();
    }
    return map;
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
  List<String>? langages;
  int? coinsPerMinute;
  dynamic upgradeLink;
  dynamic upgrateDoc;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  int? activeStatus;
  String? resumeUrl;
  List<TodaySlots>? todaySlots;
  List<TomorrowSlots>? tomorrowSlots;
  int? remainingSlots;
  String? slotsMessage;
  double? averageRating;
  int? totalReviews;
  List<Reviews>? reviews;
  User? user;
  List<Expertises>? expertises;
  List<Ratings>? ratings;
  MentorData({
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
    this.upgradeLink,
    this.upgrateDoc,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.activeStatus,
    this.resumeUrl,
    this.todaySlots,
    this.tomorrowSlots,
    this.remainingSlots,
    this.slotsMessage,
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
    langages = json['langages'] != null
        ? List<String>.from(json['langages'])
        : [];
    coinsPerMinute = json['coins_per_minute'] is String
        ? int.tryParse(json['coins_per_minute'])
        : json['coins_per_minute'];
    upgradeLink = json['upgrade_link'];
    upgrateDoc = json['upgrate_doc'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    remainingSlots = json['remaining_slots_this_week'];
    slotsMessage = json['slots_message'];
    activeStatus = json['active_status'];
    resumeUrl = json['resume_url'];

    if (json['today_slots'] != null) {
      todaySlots = (json['today_slots'] as List)
          .map((v) => TodaySlots.fromJson(v))
          .toList();
    }
    if (json['tomorrow_slots'] != null) {
      tomorrowSlots = (json['tomorrow_slots'] as List)
          .map((v) => TomorrowSlots.fromJson(v))
          .toList();
    }

    averageRating = json['average_rating'] != null
        ? double.tryParse(json['average_rating'].toString())
        : null;
    totalReviews = json['total_reviews'];

    if (json['reviews'] != null) {
      reviews = (json['reviews'] as List)
          .map((v) => Reviews.fromJson(v))
          .toList();
    }

    user = json['user'] != null ? User.fromJson(json['user']) : null;

    if (json['expertises'] != null) {
      expertises = (json['expertises'] as List)
          .map((v) => Expertises.fromJson(v))
          .toList();
    }

    if (json['ratings'] != null) {
      ratings = (json['ratings'] as List)
          .map((v) => Ratings.fromJson(v))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['id'] = id;
    map['user_id'] = userId;
    map['reason_for_become_mentor'] = reasonForBecomeMentor;
    map['achivements'] = achivements;
    map['portfolio'] = portfolio;
    map['linked_in'] = linkedIn;
    map['git_hub'] = gitHub;
    map['resume'] = resume;
    map['langages'] = langages;
    map['coins_per_minute'] = coinsPerMinute;
    map['upgrade_link'] = upgradeLink;
    map['upgrate_doc'] = upgrateDoc;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['deleted_at'] = deletedAt;
    map['active_status'] = activeStatus;
    map['resume_url'] = resumeUrl;
    if (todaySlots != null)
      map['today_slots'] = todaySlots!.map((v) => v.toJson()).toList();
    if (tomorrowSlots != null)
      map['tomorrow_slots'] = tomorrowSlots!.map((v) => v.toJson()).toList();
    map['average_rating'] = averageRating;
    map['total_reviews'] = totalReviews;
    map['remaining_slots_this_week'] = this.remainingSlots;
    map['slots_message'] = this.slotsMessage;
    if (reviews != null)
      map['reviews'] = reviews!.map((v) => v.toJson()).toList();
    if (user != null) map['user'] = user!.toJson();
    if (expertises != null)
      map['expertises'] = expertises!.map((v) => v.toJson()).toList();
    if (ratings != null)
      map['ratings'] = ratings!.map((v) => v.toJson()).toList();
    return map;
  }
}

class TodaySlots {
  int? id;
  String? date;
  String? startTime;
  String? endTime;
  String? status;

  TodaySlots({this.id, this.date, this.startTime, this.endTime, this.status});

  TodaySlots.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'start_time': startTime,
      'end_time': endTime,
      'status': status,
    };
  }
}

class TomorrowSlots {
  int? id;
  String? date;
  String? startTime;
  String? endTime;
  String? status;

  TomorrowSlots({
    this.id,
    this.date,
    this.startTime,
    this.endTime,
    this.status,
  });

  TomorrowSlots.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'start_time': startTime,
      'end_time': endTime,
      'status': status,
    };
  }
}

class Reviews {
  int? id;
  int? userId;
  int? rating;
  String? createdAt;
  User? user;

  Reviews({this.id, this.userId, this.rating, this.createdAt, this.user});

  Reviews.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    rating = json['rating'];
    createdAt = json['created_at'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'rating': rating,
      'created_at': createdAt,
      if (user != null) 'user': user!.toJson(),
    };
  }
}

class User {
  int? id;
  String? name;
  String? email;
  int? contact;
  String? refreshToken;
  String? webFcmToken;
  String? deviceFcmToken;
  String? role;
  String? bio;
  int? collegeId;
  String? year;
  String? stream;
  String? status;
  String? profilePic;
  String? saasId;
  String? createdAt;
  String? updatedAt;
  int? activeStatus;
  String? lastLoginAt;
  String? mentorStatus;
  String? profilePicUrl;

  User({
    this.id,
    this.name,
    this.email,
    this.contact,
    this.refreshToken,
    this.webFcmToken,
    this.deviceFcmToken,
    this.role,
    this.bio,
    this.collegeId,
    this.year,
    this.stream,
    this.status,
    this.profilePic,
    this.saasId,
    this.createdAt,
    this.updatedAt,
    this.activeStatus,
    this.lastLoginAt,
    this.mentorStatus,
    this.profilePicUrl,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    contact = json['contact'];
    refreshToken = json['refresh_token'];
    webFcmToken = json['web_fcm_token'];
    deviceFcmToken = json['device_fcm_token'];
    role = json['role'];
    bio = json['bio'];
    collegeId = json['college_id'];
    year = json['year'];
    stream = json['stream'];
    status = json['status'];
    profilePic = json['profile_pic'];
    saasId = json['saas_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    activeStatus = json['active_status'];
    lastLoginAt = json['last_login_at'];
    mentorStatus = json['mentor_status'];
    profilePicUrl = json['profile_pic_url'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'contact': contact,
      'refresh_token': refreshToken,
      'web_fcm_token': webFcmToken,
      'device_fcm_token': deviceFcmToken,
      'role': role,
      'bio': bio,
      'college_id': collegeId,
      'year': year,
      'stream': stream,
      'status': status,
      'profile_pic': profilePic,
      'saas_id': saasId,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'active_status': activeStatus,
      'last_login_at': lastLoginAt,
      'mentor_status': mentorStatus,
      'profile_pic_url': profilePicUrl,
    };
  }
}

class Expertises {
  int? id;
  String? name;
  int? baseValue;
  List<SubExpertises>? subExpertises;

  Expertises({this.id, this.name, this.baseValue, this.subExpertises});

  Expertises.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    baseValue = json['base_value'];
    if (json['sub_expertises'] != null) {
      subExpertises = (json['sub_expertises'] as List)
          .map((v) => SubExpertises.fromJson(v))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'base_value': baseValue,
      if (subExpertises != null)
        'sub_expertises': subExpertises!.map((v) => v.toJson()).toList(),
    };
  }
}

class SubExpertises {
  int? id;
  String? name;
  int? baseValue;

  SubExpertises({this.id, this.name, this.baseValue});

  SubExpertises.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    baseValue = json['base_value'];
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'base_value': baseValue};
  }
}

class Ratings {
  int? id;
  int? mentorId;
  int? userId;
  int? sessionId;
  int? rating;
  String? feedback;
  String? createdAt;
  dynamic updatedAt;
  dynamic deletedAt;
  User? user;

  Ratings({
    this.id,
    this.mentorId,
    this.userId,
    this.sessionId,
    this.rating,
    this.feedback,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.user,
  });

  Ratings.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mentorId = json['mentor_id'];
    userId = json['user_id'];
    sessionId = json['session_id'];
    rating = json['rating'];
    feedback = json['feedback'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mentor_id': mentorId,
      'user_id': userId,
      'session_id': sessionId,
      'rating': rating,
      'feedback': feedback,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      if (user != null) 'user': user!.toJson(),
    };
  }
}
