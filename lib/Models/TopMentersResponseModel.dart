// lib/models/TopmentersResponseModel.dart

class Topmentersresponsemodel {
  bool? status;
  TopMentors? data;

  Topmentersresponsemodel({this.status, this.data});

  Topmentersresponsemodel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? TopMentors.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> m = <String, dynamic>{};
    m['status'] = status;
    if (data != null) {
      m['data'] = data!.toJson();
    }
    return m;
  }
}

class TopMentors {
  int? currentPage;
  List<MentorData>? mentordata;
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

  TopMentors({
    this.currentPage,
    this.mentordata,
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

  TopMentors.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      mentordata = <MentorData>[];
      for (var v in json['data']) {
        mentordata!.add(MentorData.fromJson(v));
      }
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    if (json['links'] != null) {
      links = <Links>[];
      for (var v in json['links']) {
        links!.add(Links.fromJson(v));
      }
    }
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> m = <String, dynamic>{};
    m['current_page'] = currentPage;
    if (mentordata != null) {
      m['data'] = mentordata!.map((v) => v.toJson()).toList();
    }
    m['first_page_url'] = firstPageUrl;
    m['from'] = from;
    m['last_page'] = lastPage;
    m['last_page_url'] = lastPageUrl;
    if (links != null) {
      m['links'] = links!.map((v) => v.toJson()).toList();
    }
    m['next_page_url'] = nextPageUrl;
    m['path'] = path;
    m['per_page'] = perPage;
    m['prev_page_url'] = prevPageUrl;
    m['to'] = to;
    m['total'] = total;
    return m;
  }
}

class MentorData {
  int? id;
  String? name;
  String? email;
  int? contact;
  String? role;
  String? designation;
  int? exp;
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
  int? ratingsReceivedCount;
  double? ratingsReceivedAvgRating;
  String? profilePicUrl;

  MentorData({
    this.id,
    this.name,
    this.email,
    this.contact,
    this.role,
    this.designation,
    this.exp,
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
    this.ratingsReceivedCount,
    this.ratingsReceivedAvgRating,
    this.profilePicUrl,
  });

  MentorData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    contact = json['contact'];
    role = json['role'];
    designation = json['designation'];
    exp = json['exp'];
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

    // safe conversion from int or double to double
    final rawRating = json['ratings_received_avg_rating'];
    ratingsReceivedAvgRating = (rawRating as num?)?.toDouble();

    ratingsReceivedCount = json['ratings_received_count'];
    profilePicUrl = json['profile_pic_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> m = <String, dynamic>{};
    m['id'] = id;
    m['name'] = name;
    m['email'] = email;
    m['contact'] = contact;
    m['role'] = role;
    m['designation'] = designation;
    m['exp'] = exp;
    m['bio'] = bio;
    m['college_id'] = collegeId;
    m['year'] = year;
    m['stream'] = stream;
    m['status'] = status;
    m['profile_pic'] = profilePic;
    m['saas_id'] = saasId;
    m['created_at'] = createdAt;
    m['updated_at'] = updatedAt;
    m['active_status'] = activeStatus;
    m['last_login_at'] = lastLoginAt;
    m['ratings_received_count'] = ratingsReceivedCount;
    m['ratings_received_avg_rating'] = ratingsReceivedAvgRating;
    m['profile_pic_url'] = profilePicUrl;
    return m;
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
    final Map<String, dynamic> m = <String, dynamic>{};
    m['url'] = url;
    m['label'] = label;
    m['active'] = active;
    return m;
  }
}
