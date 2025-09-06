class CommunityPostsModel {
  bool? status;
  Data? data;

  CommunityPostsModel({this.status, this.data});

  CommunityPostsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    if (this.data != null) data['data'] = this.data!.toJson();
    return data;
  }
}

class Data {
  int? currentPage;
  List<CommunityPosts>? communityposts;
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
    this.communityposts,
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
      communityposts = [];
      json['data'].forEach((v) {
        communityposts!.add(CommunityPosts.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    if (json['links'] != null) {
      links = [];
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
    if (communityposts != null) {
      data['data'] = communityposts!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = firstPageUrl;
    data['from'] = from;
    data['last_page'] = lastPage;
    data['last_page_url'] = lastPageUrl;
    if (links != null) data['links'] = links!.map((v) => v.toJson()).toList();
    data['next_page_url'] = nextPageUrl;
    data['path'] = path;
    data['per_page'] = perPage;
    data['prev_page_url'] = prevPageUrl;
    data['to'] = to;
    data['total'] = total;
    return data;
  }
}

class CommunityPosts {
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
  int? likesCount;
  bool? isLiked;
  int? commentsCount;
  String? imgUrl;
  Uploader? uploader;
  List<Comments>? comments;

  CommunityPosts({
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
    this.isLiked,
  });

  CommunityPosts.fromJson(Map<String, dynamic> json) {
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
    likesCount = json['likes_count'];
    isLiked = json['is_liked'];
    commentsCount = json['comments_count'];
    imgUrl = json['img_url'];
    uploader = json['uploader'] != null
        ? Uploader.fromJson(json['uploader'])
        : null;

    if (json['comments'] != null) {
      comments = [];
      json['comments'].forEach((v) {
        comments!.add(Comments.fromJson(v));
      });
    } else {
      comments = [];
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
    data['is_liked'] = isLiked;
    data['comments_count'] = commentsCount;
    data['img_url'] = imgUrl;
    if (uploader != null) data['uploader'] = uploader!.toJson();
    if (comments != null)
      data['comments'] = comments!.map((v) => v.toJson()).toList();
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
  String? deletedAt;
  int? likesCount;
  bool? isLiked;
  Uploader? user;
  String? replyTo;
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
    this.likesCount,
    this.isLiked,
    this.user,
    this.replyTo,
    this.replies,
  });

  factory Comments.fromJson(Map<String, dynamic> json) {
    return Comments(
      id: json['id'],
      userId: json['user_id'],
      communityId: json['community_id'],
      parentId: json['parent_id'],
      content: json['content'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
      likesCount: json['likes_count'],
      replyTo: json['reply_to'],
      isLiked: json['is_liked'],
      user: json['user'] != null ? Uploader.fromJson(json['user']) : null,
      replies:
          (json['replies'] as List?)
              ?.map((e) => Comments.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'community_id': communityId,
      'parent_id': parentId,
      'content': content,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'likes_count': likesCount,
      'is_liked': isLiked,
      'reply_to': replyTo,
      'user': user?.toJson(),
      'replies': replies?.map((e) => e.toJson()).toList(),
    };
  }
}

class User {
  int? id;
  String? name;
  String? profilePicUrl;

  User({this.id, this.name, this.profilePicUrl});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    profilePicUrl = json['profile_pic_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['profile_pic_url'] = profilePicUrl;
    return data;
  }
}

class Uploader {
  int? id;
  String? name;
  String? profilePicUrl;

  Uploader({this.id, this.name, this.profilePicUrl});

  Uploader.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    profilePicUrl = json['profile_pic_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['profile_pic_url'] = profilePicUrl;
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
