class MenteeProfileModel {
  bool? status;
  String? message;
  Data? data;

  MenteeProfileModel({this.status, this.message, this.data});

  MenteeProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  User? user;

  Data({this.user});

  Data.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? email;
  int? contact;
  String? role;
  String? designation;
  String? exp;
  String? bio;
  int? collegeId;
  String? year;
  int? yearId;
  String? yearName;
  String?college_name;
  String? stream;
  String? status;
  String? profilePic;
  String? saasId;
  int? activeStatus;
  String? lastLoginAt;
  String? mentorStatus;
  String? profilePicUrl;
  int? availabilityCoins;
  List<StudyZoneBooks>? studyZoneBooks;
  List<CommunityPost>? communityPost;

  User(
      {this.id,
        this.name,
        this.email,
        this.contact,
        this.role,
        this.designation,
        this.exp,
        this.bio,
        this.collegeId,
        this.college_name,
        this.year,
        this.yearId,
        this.yearName,
        this.stream,
        this.status,
        this.profilePic,
        this.saasId,
        this.activeStatus,
        this.lastLoginAt,
        this.mentorStatus,
        this.profilePicUrl,
        this.availabilityCoins,
        this.studyZoneBooks,
        this.communityPost});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    contact = json['contact'];
    role = json['role'];
    designation = json['designation'];
    exp = json['exp'];
    bio = json['bio'];
    collegeId = json['college_id'];
    college_name=  json['college_name'];
    year = json['year'];
    yearId = json['year_id'];
    yearName = json['year_name'];
    stream = json['stream'];
    status = json['status'];
    profilePic = json['profile_pic'];
    saasId = json['saas_id'];
    activeStatus = json['active_status'];
    lastLoginAt = json['last_login_at'];
    mentorStatus = json['mentor_status'];
    profilePicUrl = json['profile_pic_url'];
    availabilityCoins = json['availability_coins'];
    if (json['study_zone_books'] != null) {
      studyZoneBooks = <StudyZoneBooks>[];
      json['study_zone_books'].forEach((v) {
        studyZoneBooks!.add(new StudyZoneBooks.fromJson(v));
      });
    }
    if (json['community_post'] != null) {
      communityPost = <CommunityPost>[];
      json['community_post'].forEach((v) {
        communityPost!.add(new CommunityPost.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['contact'] = this.contact;
    data['role'] = this.role;
    data['designation'] = this.designation;
    data['exp'] = this.exp;
    data['bio'] = this.bio;
    data['college_id'] = this.collegeId;
    data['college_name'] = this.college_name;
    data['year'] = this.year;
    data['year_id'] = this.yearId;
    data['year_name'] = this.yearName;
    data['stream'] = this.stream;
    data['status'] = this.status;
    data['profile_pic'] = this.profilePic;
    data['saas_id'] = this.saasId;
    data['active_status'] = this.activeStatus;
    data['last_login_at'] = this.lastLoginAt;
    data['mentor_status'] = this.mentorStatus;
    data['profile_pic_url'] = this.profilePicUrl;
    data['availability_coins'] = this.availabilityCoins;
    if (this.studyZoneBooks != null) {
      data['study_zone_books'] =
          this.studyZoneBooks!.map((v) => v.toJson()).toList();
    }
    if (this.communityPost != null) {
      data['community_post'] =
          this.communityPost!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StudyZoneBooks {
  int? id;
  String? title;
  List<String>? tags;
  String? image;
  String? description;
  String? filePdf;
  int? downloads;
  String? createdAt;

  StudyZoneBooks(
      {this.id,
        this.title,
        this.tags,
        this.image,
        this.description,
        this.filePdf,
        this.downloads,
        this.createdAt});

  StudyZoneBooks.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    tags = json['tags'].cast<String>();
    image = json['image'];
    description = json['description'];
    filePdf = json['file_pdf'];
    downloads = json['downloads'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['tags'] = this.tags;
    data['image'] = this.image;
    data['description'] = this.description;
    data['file_pdf'] = this.filePdf;
    data['downloads'] = this.downloads;
    data['created_at'] = this.createdAt;
    return data;
  }
}

class CommunityPost {
  int? id;
  String? title;
  String? content;
  String? image;
  int? likesCount;
  int? commentsCount;
  String? createdAt;

  CommunityPost(
      {this.id,
        this.title,
        this.content,
        this.image,
        this.likesCount,
        this.commentsCount,
        this.createdAt});

  CommunityPost.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    image = json['image'];
    likesCount = json['likes_count'];
    commentsCount = json['comments_count'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['content'] = this.content;
    data['image'] = this.image;
    data['likes_count'] = this.likesCount;
    data['comments_count'] = this.commentsCount;
    data['created_at'] = this.createdAt;
    return data;
  }
}
