import 'CommunityPostsModel.dart';

class CommonProfileModel {
  bool? status;
  String? message;
  Data? data;

  CommonProfileModel({this.status, this.message, this.data});

  CommonProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    data['message'] = message;
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
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? email;
  String? contact; // safer as String, API might send numeric or string
  String? role;
  String? designation;
  String? exp;
  String? bio;
  int? collegeId;
  String? collegeName;
  String? year;
  int? yearId;
  String? yearName;
  String? stream;
  String? status;
  String? profilePic;
  String? profilePicUrl;
  String? saasId;
  int? activeStatus;
  String? lastLoginAt;
  String? mentorStatus;
  int? availabilityCoins;
  List<StudyZoneBook>? studyZoneBooks;
  List<CommunityPosts>? communityPost;

  User({
    this.id,
    this.name,
    this.email,
    this.contact,
    this.role,
    this.designation,
    this.exp,
    this.bio,
    this.collegeId,
    this.collegeName,
    this.year,
    this.yearId,
    this.yearName,
    this.stream,
    this.status,
    this.profilePic,
    this.profilePicUrl,
    this.saasId,
    this.activeStatus,
    this.lastLoginAt,
    this.mentorStatus,
    this.availabilityCoins,
    this.studyZoneBooks,
    this.communityPost,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    contact = json['contact'].toString();
    role = json['role'];
    designation = json['designation'];
    exp = json['exp'];
    bio = json['bio'];
    collegeId = json['college_id'];
    collegeName = json['college_name'];
    year = json['year'];
    yearId = json['year_id'];
    yearName = json['year_name'];
    stream = json['stream'];
    status = json['status'];
    profilePic = json['profile_pic'];
    profilePicUrl = json['profile_pic_url'];
    saasId = json['saas_id'];
    activeStatus = json['active_status'];
    lastLoginAt = json['last_login_at'];
    mentorStatus = json['mentor_status'];
    availabilityCoins = json['availability_coins'];

    // study_zone_books
    if (json['study_zone_books'] != null) {
      studyZoneBooks = <StudyZoneBook>[];
      json['study_zone_books'].forEach((v) {
        studyZoneBooks!.add(StudyZoneBook.fromJson(v));
      });
    }

    // community_post
    if (json['community_post'] != null) {
      communityPost = <CommunityPosts>[];
      json['community_post'].forEach((v) {
        communityPost!.add(CommunityPosts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['contact'] = contact;
    data['role'] = role;
    data['designation'] = designation;
    data['exp'] = exp;
    data['bio'] = bio;
    data['college_id'] = collegeId;
    data['college_name'] = collegeName;
    data['year'] = year;
    data['year_id'] = yearId;
    data['year_name'] = yearName;
    data['stream'] = stream;
    data['status'] = status;
    data['profile_pic'] = profilePic;
    data['profile_pic_url'] = profilePicUrl;
    data['saas_id'] = saasId;
    data['active_status'] = activeStatus;
    data['last_login_at'] = lastLoginAt;
    data['mentor_status'] = mentorStatus;
    data['availability_coins'] = availabilityCoins;

    if (studyZoneBooks != null) {
      data['study_zone_books'] = studyZoneBooks!
          .map((v) => v.toJson())
          .toList();
    }
    if (communityPost != null) {
      data['community_post'] = communityPost!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StudyZoneBook {
  int? id;
  String? title;
  List<String>? tags;
  String? image;
  String? description;
  String? filePdf;
  int? downloads;
  String? createdAt;

  StudyZoneBook({
    this.id,
    this.title,
    this.tags,
    this.image,
    this.description,
    this.filePdf,
    this.downloads,
    this.createdAt,
  });

  StudyZoneBook.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];

    // handle null / string / list
    if (json['tags'] != null) {
      if (json['tags'] is List) {
        tags = List<String>.from(json['tags']);
      } else if (json['tags'] is String) {
        tags = [json['tags']];
      }
    } else {
      tags = [];
    }

    image = json['image'];
    description = json['description'];
    filePdf = json['file_pdf'];
    downloads = json['downloads'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['title'] = title;
    data['tags'] = tags;
    data['image'] = image;
    data['description'] = description;
    data['file_pdf'] = filePdf;
    data['downloads'] = downloads;
    data['created_at'] = createdAt;
    return data;
  }
}

// class CommunityPost {
//   int? id;
//   String? title;
//   String? content;
//   String? image;
//   int? likesCount;
//   int? commentsCount;
//   String? createdAt;
//   bool? isLike;
//
//   CommunityPost({
//     this.id,
//     this.title,
//     this.content,
//     this.image,
//     this.likesCount,
//     this.commentsCount,
//     this.createdAt,
//     this.isLike,
//   });
//
//   CommunityPost.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     title = json['title'];
//     content = json['content'];
//     image = json['image'];
//     likesCount = json['likes_count'];
//     commentsCount = json['comments_count'];
//     createdAt = json['created_at'];
//     isLike = json['is_like'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = {};
//     data['id'] = id;
//     data['title'] = title;
//     data['content'] = content;
//     data['image'] = image;
//     data['likes_count'] = likesCount;
//     data['comments_count'] = commentsCount;
//     data['created_at'] = createdAt;
//     data['is_like'] = isLike;
//     return data;
//   }
// }
