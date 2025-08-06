class GuestCommunityZonepostModel{
  bool? status;
  Data? data;

  GuestCommunityZonepostModel({this.status, this.data});

  GuestCommunityZonepostModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? currentPage;
  List<GuestcommunitypostData>? data;
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
    this.data,
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
      data = <GuestcommunitypostData>[];
      json['data'].forEach((v) {
        data!.add(GuestcommunitypostData.fromJson(v));
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
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
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

class GuestcommunitypostData {
  int? id;
  String? heading;
  String? description;
  List<String>? tags;
  String? image;
  int? anonymous;
  int? popular;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  int? activeStatus;
  int? uploadedBy;
  int? collegeId;
  int? likesCount;
  int? commentsCount;
  String? imgUrl;
  Uploader? uploader;
  List<Comments>? comments;

  GuestcommunitypostData({
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
    this.likesCount,
    this.commentsCount,
    this.imgUrl,
    this.uploader,
    this.comments,
  });

  GuestcommunitypostData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    heading = json['heading'];
    description = json['description'];
    tags = json['tags'] != null ? List<String>.from(json['tags']) : null;
    image = json['image'];
    anonymous = json['anonymous'];
    popular = json['popular'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    activeStatus = json['active_status'];
    uploadedBy = json['uploadedBy'];
    collegeId = json['college_id'];
    likesCount = json['likes_count'];
    commentsCount = json['comments_count'];
    imgUrl = json['img_url'];
    uploader = json['uploader'] != null ? Uploader.fromJson(json['uploader']) : null;
    if (json['comments'] != null) {
      comments = <Comments>[];
      json['comments'].forEach((v) {
        comments!.add(Comments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['heading'] = heading;
    data['description'] = description;
    data['tags'] = tags;
    data['image'] = image;
    data['anonymous'] = anonymous;
    data['popular'] = popular;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['active_status'] = activeStatus;
    data['uploadedBy'] = uploadedBy;
    data['college_id'] = collegeId;
    data['likes_count'] = likesCount;
    data['comments_count'] = commentsCount;
    data['img_url'] = imgUrl;
    if (uploader != null) {
      data['uploader'] = uploader!.toJson();
    }
    if (comments != null) {
      data['comments'] = comments!.map((v) => v.toJson()).toList();
    }
    return data;
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
  String? designation;
  int? exp;
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
    return data;
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
  dynamic deletedAt;
  Uploader? user;
  List<Comments>? replies;

  Comments({
    this.id,
    this.userId,
    this.communityId,
    this.parentId,
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
    content = json['content'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    user = json['user'] != null ? Uploader.fromJson(json['user']) : null;
    if (json['replies'] != null) {
      replies = <Comments>[];
      json['replies'].forEach((v) {
        replies!.add(Comments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['user_id'] = userId;
    data['community_id'] = communityId;
    data['parent_id'] = parentId;
    data['content'] = content;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (replies != null) {
      data['replies'] = replies!.map((v) => v.toJson()).toList();
    }
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
