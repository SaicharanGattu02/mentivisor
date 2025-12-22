class RegisterModel {
  bool? status;
  String? message;
  Data? data;

  RegisterModel({this.status, this.message, this.data});

  RegisterModel.fromJson(Map<String, dynamic> json) {
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
  String? profileUrl;
  String? accessToken;
  String? refreshToken;
  String? role;
  String? tokenType;
  int? expiresIn;

  Data({
    this.user,
    this.profileUrl,
    this.accessToken,
    this.refreshToken,
    this.role,
    this.tokenType,
    this.expiresIn,
  });

  Data.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    profileUrl = json['profile_url'];
    accessToken = json['access_token'];
    refreshToken = json['refresh_token'];
    role = json['role'];
    tokenType = json['token_type'];
    expiresIn = json['expires_in'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['profile_url'] = this.profileUrl;
    data['access_token'] = this.accessToken;
    data['refresh_token'] = this.refreshToken;
    data['role'] = this.role;
    data['token_type'] = this.tokenType;
    data['expires_in'] = this.expiresIn;
    return data;
  }
}

class User {
  String? name;
  String? email;
  dynamic contact;
  String? bio;
  String? collegeId;
  String? year;
  String? stream;
  String? profilePic;
  String? deviceFcmToken;
  String? updatedAt;
  String? createdAt;
  int? id;
  String? refreshToken;
  String? profilePicUrl;

  User({
    this.name,
    this.email,
    this.contact,
    this.bio,
    this.collegeId,
    this.year,
    this.stream,
    this.profilePic,
    this.deviceFcmToken,
    this.updatedAt,
    this.createdAt,
    this.id,
    this.refreshToken,
    this.profilePicUrl,
  });

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    contact = json['contact'];
    bio = json['bio'];
    collegeId = json['college_id'];
    year = json['year'];
    stream = json['stream'];
    profilePic = json['profile_pic'];
    deviceFcmToken = json['device_fcm_token'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'] is int
        ? json['id']
        : int.tryParse(json['id']?.toString() ?? '');
    refreshToken = json['refresh_token'];
    profilePicUrl = json['profile_pic_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['contact'] = this.contact;
    data['bio'] = this.bio;
    data['college_id'] = this.collegeId;
    data['year'] = this.year;
    data['stream'] = this.stream;
    data['profile_pic'] = this.profilePic;
    data['device_fcm_token'] = this.deviceFcmToken;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    data['refresh_token'] = this.refreshToken;
    data['profile_pic_url'] = this.profilePicUrl;
    return data;
  }
}
