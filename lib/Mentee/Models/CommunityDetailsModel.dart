import 'CommunityPostsModel.dart';

class CommunityDetailsModel {
  bool? status;
  String? message;
  CommunityPosts? communityposts;

  CommunityDetailsModel({this.status, this.communityposts, this.message});

  CommunityDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    communityposts = json['data'] != null ? CommunityPosts.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['status'] = status;
    map['message'] = message;
    if (communityposts != null) {
      map['data'] = communityposts!.toJson();
    }
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
  String? webFcmToken;
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
    map['top_mentor_rank'] = topMentorRank;
    map['profile_pic_url'] = profilePicUrl;
    return map;
  }
}

class Comments {
  int? id;
  int? userId;
  int? communityId;
  int? parentId;
  dynamic hashuser;
  String? content;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  Uploader? user;
  List<Replies>? replies;

  Comments({
    this.id,
    this.userId,
    this.communityId,
    this.parentId,
    this.hashuser,
    this.content,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.user,
    this.replies,
  });

  Comments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    communityId = json['community_id'];
    parentId = json['parent_id'];
    hashuser = json['hashuser'];
    content = json['content'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    user = json['user'] != null ? Uploader.fromJson(json['user']) : null;
    if (json['replies'] != null) {
      replies = (json['replies'] as List)
          .map((v) => Replies.fromJson(v))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['id'] = id;
    map['user_id'] = userId;
    map['community_id'] = communityId;
    map['parent_id'] = parentId;
    map['hashuser'] = hashuser;
    map['content'] = content;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['deleted_at'] = deletedAt;
    if (user != null) {
      map['user'] = user!.toJson();
    }
    if (replies != null) {
      map['replies'] = replies!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Replies {
  int? id;
  int? userId;
  int? communityId;
  int? parentId;
  dynamic hashuser;
  String? content;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  Uploader? user;
  List<Replies>? replies; // ✅ allow nested replies

  Replies({
    this.id,
    this.userId,
    this.communityId,
    this.parentId,
    this.hashuser,
    this.content,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.user,
    this.replies,
  });

  Replies.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    communityId = json['community_id'];
    parentId = json['parent_id'];
    hashuser = json['hashuser'];
    content = json['content'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    user = json['user'] != null ? Uploader.fromJson(json['user']) : null;
    if (json['replies'] != null) {
      replies =
          (json['replies'] as List).map((v) => Replies.fromJson(v)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['id'] = id;
    map['user_id'] = userId;
    map['community_id'] = communityId;
    map['parent_id'] = parentId;
    map['hashuser'] = hashuser;
    map['content'] = content;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['deleted_at'] = deletedAt;
    if (user != null) {
      map['user'] = user!.toJson();
    }
    if (replies != null) {
      map['replies'] = replies!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
