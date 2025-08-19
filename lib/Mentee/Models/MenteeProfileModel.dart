class MenteeProfileModel {
  bool? status;
  String? message;
  Data? data;

  MenteeProfileModel({this.status, this.message, this.data});

  MenteeProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['status'] = status;
    map['message'] = message;
    if (data != null) {
      map['data'] = data!.toJson();
    }
    return map;
  }
}

class Data {
  User? user;

  Data({this.user});

  Data.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    if (user != null) {
      map['user'] = user!.toJson();
    }
    return map;
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
  String? emailOtp;
  String? expiredTime;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  int? activeStatus;
  String? lastLoginAt;
  String? mentorStatus;
  String? profilePicUrl;
  int? availabilityCoins;
  List<StudyZoneBooks>? studyZoneBooks;
  List<CommunityPost>? communityPost;

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
    this.availabilityCoins,
    this.studyZoneBooks,
    this.communityPost,
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
    availabilityCoins = json['availability_coins'];

    if (json['study_zone_books'] != null) {
      studyZoneBooks = (json['study_zone_books'] as List)
          .map((v) => StudyZoneBooks.fromJson(v))
          .toList();
    }

    if (json['community_post'] != null) {
      communityPost = (json['community_post'] as List)
          .map((v) => CommunityPost.fromJson(v))
          .toList();
    }
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
    map['active_status'] = activeStatus;
    map['last_login_at'] = lastLoginAt;
    map['mentor_status'] = mentorStatus;
    map['profile_pic_url'] = profilePicUrl;
    map['availability_coins'] = availabilityCoins;

    if (studyZoneBooks != null) {
      map['study_zone_books'] =
          studyZoneBooks!.map((v) => v.toJson()).toList();
    }

    if (communityPost != null) {
      map['community_post'] =
          communityPost!.map((v) => v.toJson()).toList();
    }

    return map;
  }
}

class StudyZoneBooks {
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

  StudyZoneBooks({
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
  });

  StudyZoneBooks.fromJson(Map<String, dynamic> json) {
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['id'] = id;
    map['name'] = name;
    map['image'] = image;
    map['tag'] = tag;
    map['file_pdf'] = filePdf;
    map['description'] = description;
    map['uploaded_by'] = uploadedBy;
    map['downloads_count'] = downloadsCount;
    map['college_id'] = collegeId;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['deleted_at'] = deletedAt;
    return map;
  }
}

class CommunityPost {
  int? id;
  String? heading;
  String? description;
  List<String>? tags;
  String? image;
  int? anonymous;
  int? popular;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  int? activeStatus;
  int? uploadedBy;
  int? collegeId;
  int? likeCount;
  int? messageCount;
  int? feedbackCount;
  List<Comments>? comments;
  String? imgUrl;

  CommunityPost({
    this.id,
    this.heading,
    this.description,
    this.tags,
    this.image,
    this.anonymous,
    this.popular,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.activeStatus,
    this.uploadedBy,
    this.collegeId,
    this.likeCount,
    this.messageCount,
    this.feedbackCount,
    this.comments,
    this.imgUrl,
  });

  CommunityPost.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    heading = json['heading'];
    description = json['description'];
    tags = json['tags'] != null ? List<String>.from(json['tags']) : [];
    image = json['image'];
    anonymous = json['anonymous'];
    popular = json['popular'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    activeStatus = json['active_status'];
    uploadedBy = json['uploadedBy'];
    collegeId = json['college_id'];
    likeCount = json['like_count'];
    messageCount = json['message_count'];
    feedbackCount = json['feedback_count'];
    if (json['comments'] != null) {
      comments = (json['comments'] as List)
          .map((v) => Comments.fromJson(v))
          .toList();
    }
    imgUrl = json['img_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['id'] = id;
    map['heading'] = heading;
    map['description'] = description;
    map['tags'] = tags;
    map['image'] = image;
    map['anonymous'] = anonymous;
    map['popular'] = popular;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['deleted_at'] = deletedAt;
    map['active_status'] = activeStatus;
    map['uploadedBy'] = uploadedBy;
    map['college_id'] = collegeId;
    map['like_count'] = likeCount;
    map['message_count'] = messageCount;
    map['feedback_count'] = feedbackCount;
    if (comments != null) {
      map['comments'] = comments!.map((v) => v.toJson()).toList();
    }
    map['img_url'] = imgUrl;
    return map;
  }
}

class Comments {
  int? id;
  int? userId;
  int? communityId;
  int? parentId;
  String? content;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  int? repliesCount;
  User? user;
  List<dynamic>? replies;

  Comments({
    this.id,
    this.userId,
    this.communityId,
    this.parentId,
    this.content,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.repliesCount,
    this.user,
    this.replies,
  });

  Comments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    communityId = json['community_id'];
    parentId = json['parent_id'];
    content = json['content'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    repliesCount = json['replies_count'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    replies = json['replies'] ?? [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['id'] = id;
    map['user_id'] = userId;
    map['community_id'] = communityId;
    map['parent_id'] = parentId;
    map['content'] = content;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['deleted_at'] = deletedAt;
    map['replies_count'] = repliesCount;
    if (user != null) {
      map['user'] = user!.toJson();
    }
    map['replies'] = replies;
    return map;
  }
}
