class CommentsModel {
  bool? status;
  List<Data>? data;

  CommentsModel({this.status, this.data});

  CommentsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  int? userId;
  int? communityId;
  dynamic parentId;
  String? content;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  int? likesCount;
  bool? isLiked;
  User? user;
  List<Replies>? replies;

  Data(
      {this.id,
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
        this.replies});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    communityId = json['community_id'];
    parentId = json['parent_id'];
    content = json['content'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    likesCount = json['likes_count'];
    isLiked = json['is_liked'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    if (json['replies'] != null) {
      replies = <Replies>[];
      json['replies'].forEach((v) {
        replies!.add(new Replies.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['community_id'] = this.communityId;
    data['parent_id'] = this.parentId;
    data['content'] = this.content;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['likes_count'] = this.likesCount;
    data['is_liked'] = this.isLiked;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.replies != null) {
      data['replies'] = this.replies!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? profilePic;
  String? profilePicUrl;

  User({this.id, this.name, this.profilePic, this.profilePicUrl});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    profilePic = json['profile_pic'];
    profilePicUrl = json['profile_pic_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['profile_pic'] = this.profilePic;
    data['profile_pic_url'] = this.profilePicUrl;
    return data;
  }
}

class Replies {
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
  User? user;

  Replies(
      {this.id,
        this.userId,
        this.communityId,
        this.parentId,
        this.content,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.likesCount,
        this.isLiked,
        this.user});

  Replies.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    communityId = json['community_id'];
    parentId = json['parent_id'];
    content = json['content'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    likesCount = json['likes_count'];
    isLiked = json['is_liked'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['community_id'] = this.communityId;
    data['parent_id'] = this.parentId;
    data['content'] = this.content;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['likes_count'] = this.likesCount;
    data['is_liked'] = this.isLiked;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}
