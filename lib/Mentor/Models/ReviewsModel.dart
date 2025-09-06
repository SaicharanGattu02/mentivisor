  class ReviewsModel {
    bool? status;
    String? message;
    Data? data;

    ReviewsModel({this.status, this.message, this.data});

    ReviewsModel.fromJson(Map<String, dynamic> json) {
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
    int? currentPage;
    List<Reviews>? reviews;
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

    Data(
        {this.currentPage,
          this.reviews,
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
          this.total});

    Data.fromJson(Map<String, dynamic> json) {
      currentPage = json['current_page'];
      if (json['data'] != null) {
        reviews = <Reviews>[];
        json['data'].forEach((v) {
          reviews!.add(new Reviews.fromJson(v));
        });
      }
      firstPageUrl = json['first_page_url'];
      from = json['from'];
      lastPage = json['last_page'];
      lastPageUrl = json['last_page_url'];
      if (json['links'] != null) {
        links = <Links>[];
        json['links'].forEach((v) {
          links!.add(new Links.fromJson(v));
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
      final Map<String, dynamic> data = new Map<String, dynamic>();
      data['current_page'] = this.currentPage;
      if (this.reviews != null) {
        data['data'] = this.reviews!.map((v) => v.toJson()).toList();
      }
      data['first_page_url'] = this.firstPageUrl;
      data['from'] = this.from;
      data['last_page'] = this.lastPage;
      data['last_page_url'] = this.lastPageUrl;
      if (this.links != null) {
        data['links'] = this.links!.map((v) => v.toJson()).toList();
      }
      data['next_page_url'] = this.nextPageUrl;
      data['path'] = this.path;
      data['per_page'] = this.perPage;
      data['prev_page_url'] = this.prevPageUrl;
      data['to'] = this.to;
      data['total'] = this.total;
      return data;
    }
  }

  class Reviews {
    int? id;
    User? user;
    Session? session;
    String? tag;
    int? rating;
    String? feedback;
    String? date;

    Reviews(
        {this.id,
          this.user,
          this.session,
          this.tag,
          this.rating,
          this.feedback,
          this.date});

    Reviews.fromJson(Map<String, dynamic> json) {
      id = json['id'];
      user = json['user'] != null ? new User.fromJson(json['user']) : null;
      session =
      json['session'] != null ? new Session.fromJson(json['session']) : null;
      tag = json['tag'];
      rating = json['rating'];
      feedback = json['feedback'];
      date = json['date'];
    }

    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = new Map<String, dynamic>();
      data['id'] = this.id;
      if (this.user != null) {
        data['user'] = this.user!.toJson();
      }
      if (this.session != null) {
        data['session'] = this.session!.toJson();
      }
      data['tag'] = this.tag;
      data['rating'] = this.rating;
      data['feedback'] = this.feedback;
      data['date'] = this.date;
      return data;
    }
  }

  class User {
    int? id;
    String? name;
    String? image;
    String? institution;

    User({this.id, this.name, this.image, this.institution});

    User.fromJson(Map<String, dynamic> json) {
      id = json['id'];
      name = json['name'];
      image = json['image'];
      institution = json['institution'];
    }

    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = new Map<String, dynamic>();
      data['id'] = this.id;
      data['name'] = this.name;
      data['image'] = this.image;
      data['institution'] = this.institution;
      return data;
    }
  }

  class Session {
    int? id;
    String? date;

    Session({this.id, this.date});

    Session.fromJson(Map<String, dynamic> json) {
      id = json['id'];
      date = json['date'];
    }

    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = new Map<String, dynamic>();
      data['id'] = this.id;
      data['date'] = this.date;
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
      final Map<String, dynamic> data = new Map<String, dynamic>();
      data['url'] = this.url;
      data['label'] = this.label;
      data['active'] = this.active;
      return data;
    }
  }
