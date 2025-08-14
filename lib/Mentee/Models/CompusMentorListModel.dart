class CompusMentorListModel {
  bool? status;
  Data? data;

  CompusMentorListModel({this.status, this.data});

  CompusMentorListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? currentPage;
  List<CampusMentorData>? campusMentorData;

  Data({this.currentPage, this.campusMentorData});

  Data.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      campusMentorData = <CampusMentorData>[];
      json['data'].forEach((v) {
        campusMentorData!.add(CampusMentorData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['current_page'] = currentPage;
    if (campusMentorData != null) {
      data['data'] = campusMentorData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CampusMentorData {
  int? id;
  String? reasonForBecomeMentor;
  String? achivements;
  String? portfolio;
  String? linkedIn;
  String? gitHub;
  String? resume;
  List<String>? langages;
  int? coinsPerMinute;
  int? activeStatus;
  String? resumeUrl;
  double? ratingsReceivedAvgRating;
  int? ratingsReceivedCount;

  // Nested `user` fields
  String? name;
  String? designation;
  String? profilePicUrl;
  String? contact;

  CampusMentorData({
    this.id,
    this.reasonForBecomeMentor,
    this.achivements,
    this.portfolio,
    this.linkedIn,
    this.gitHub,
    this.resume,
    this.langages,
    this.coinsPerMinute,
    this.activeStatus,
    this.resumeUrl,
    this.ratingsReceivedAvgRating,
    this.ratingsReceivedCount,
    this.name,
    this.designation,
    this.profilePicUrl,
    this.contact,
  });

  CampusMentorData.fromJson(Map<String, dynamic> json) {
    // Safely parse int values whether they come as string or int
    id = json['id'] is String ? int.tryParse(json['id']) : json['id'];
    reasonForBecomeMentor = json['reason_for_become_mentor'];
    achivements = json['achivements'];
    portfolio = json['portfolio'];
    linkedIn = json['linked_in'];
    gitHub = json['git_hub'];
    resume = json['resume'];

    langages = json['langages'] != null ? List<String>.from(json['langages']) : [];

    coinsPerMinute = json['coins_per_minute'] is String
        ? int.tryParse(json['coins_per_minute'])
        : json['coins_per_minute'];

    activeStatus = json['active_status'] is String
        ? int.tryParse(json['active_status'])
        : json['active_status'];

    resumeUrl = json['resume_url'];

    ratingsReceivedAvgRating = json['average_rating'] != null
        ? double.tryParse(json['average_rating'].toString())
        : null;

    ratingsReceivedCount = json['total_reviews'] is String
        ? int.tryParse(json['total_reviews'])
        : json['total_reviews'];

    if (json['user'] != null) {
      name = json['user']['name'];
      designation = json['user']['designation'];
      profilePicUrl = json['user']['profile_pic_url'];
      contact = json['user']['contact']?.toString();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['reason_for_become_mentor'] = reasonForBecomeMentor;
    data['achivements'] = achivements;
    data['portfolio'] = portfolio;
    data['linked_in'] = linkedIn;
    data['git_hub'] = gitHub;
    data['resume'] = resume;
    data['langages'] = langages;
    data['coins_per_minute'] = coinsPerMinute;
    data['active_status'] = activeStatus;
    data['resume_url'] = resumeUrl;
    data['average_rating'] = ratingsReceivedAvgRating;
    data['total_reviews'] = ratingsReceivedCount;

    data['user'] = {
      'name': name,
      'designation': designation,
      'profile_pic_url': profilePicUrl,
      'contact': contact,
    };
    return data;
  }
}

