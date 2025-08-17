class FeedbackModel {
  bool? status;
  String? message;
  Data? data;

  FeedbackModel({this.status, this.message, this.data});

  FeedbackModel.fromJson(Map<String, dynamic> json) {
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
  Overall? overall;
  FilteredOverall? filteredOverall;
  Reviews? reviews;
  AppliedFilters? appliedFilters;

  Data({this.overall, this.filteredOverall, this.reviews, this.appliedFilters});

  Data.fromJson(Map<String, dynamic> json) {
    overall = json['overall'] != null
        ? new Overall.fromJson(json['overall'])
        : null;
    filteredOverall = json['filtered_overall'] != null
        ? new FilteredOverall.fromJson(json['filtered_overall'])
        : null;
    reviews = json['reviews'] != null
        ? new Reviews.fromJson(json['reviews'])
        : null;
    appliedFilters = json['applied_filters'] != null
        ? new AppliedFilters.fromJson(json['applied_filters'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.overall != null) {
      data['overall'] = this.overall!.toJson();
    }
    if (this.filteredOverall != null) {
      data['filtered_overall'] = this.filteredOverall!.toJson();
    }
    if (this.reviews != null) {
      data['reviews'] = this.reviews!.toJson();
    }
    if (this.appliedFilters != null) {
      data['applied_filters'] = this.appliedFilters!.toJson();
    }
    return data;
  }
}

class Overall {
  double? average;
  int? totalReviews;
  Histogram? histogram;
  HistogramPct? histogramPct;
  int? avgDeltaThisMonth;

  Overall({
    this.average,
    this.totalReviews,
    this.histogram,
    this.histogramPct,
    this.avgDeltaThisMonth,
  });

  Overall.fromJson(Map<String, dynamic> json) {
    average = json['average'];
    totalReviews = json['total_reviews'];
    histogram = json['histogram'] != null
        ? new Histogram.fromJson(json['histogram'])
        : null;
    histogramPct = json['histogram_pct'] != null
        ? new HistogramPct.fromJson(json['histogram_pct'])
        : null;
    avgDeltaThisMonth = json['avg_delta_this_month'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['average'] = this.average;
    data['total_reviews'] = this.totalReviews;
    if (this.histogram != null) {
      data['histogram'] = this.histogram!.toJson();
    }
    if (this.histogramPct != null) {
      data['histogram_pct'] = this.histogramPct!.toJson();
    }
    data['avg_delta_this_month'] = this.avgDeltaThisMonth;
    return data;
  }
}

class Histogram {
  int? i1;
  int? i2;
  int? i3;
  int? i4;
  int? i5;

  Histogram({this.i1, this.i2, this.i3, this.i4, this.i5});

  Histogram.fromJson(Map<String, dynamic> json) {
    i1 = json['1'];
    i2 = json['2'];
    i3 = json['3'];
    i4 = json['4'];
    i5 = json['5'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['1'] = this.i1;
    data['2'] = this.i2;
    data['3'] = this.i3;
    data['4'] = this.i4;
    data['5'] = this.i5;
    return data;
  }
}

class HistogramPct {
  double? d1;
  double? d2;
  int? i3;
  int? i4;
  double? d5;

  HistogramPct({this.d1, this.d2, this.i3, this.i4, this.d5});

  HistogramPct.fromJson(Map<String, dynamic> json) {
    d1 = json['1'];
    d2 = json['2'];
    i3 = json['3'];
    i4 = json['4'];
    d5 = json['5'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['1'] = this.d1;
    data['2'] = this.d2;
    data['3'] = this.i3;
    data['4'] = this.i4;
    data['5'] = this.d5;
    return data;
  }
}

class FilteredOverall {
  double? average;
  int? totalReviews;
  Histogram? histogram;
  HistogramPct? histogramPct;
  double? fiveStarShare;
  Null? responseRate;

  FilteredOverall({
    this.average,
    this.totalReviews,
    this.histogram,
    this.histogramPct,
    this.fiveStarShare,
    this.responseRate,
  });

  FilteredOverall.fromJson(Map<String, dynamic> json) {
    average = json['average'];
    totalReviews = json['total_reviews'];
    histogram = json['histogram'] != null
        ? new Histogram.fromJson(json['histogram'])
        : null;
    histogramPct = json['histogram_pct'] != null
        ? new HistogramPct.fromJson(json['histogram_pct'])
        : null;
    fiveStarShare = json['five_star_share'];
    responseRate = json['response_rate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['average'] = this.average;
    data['total_reviews'] = this.totalReviews;
    if (this.histogram != null) {
      data['histogram'] = this.histogram!.toJson();
    }
    if (this.histogramPct != null) {
      data['histogram_pct'] = this.histogramPct!.toJson();
    }
    data['five_star_share'] = this.fiveStarShare;
    data['response_rate'] = this.responseRate;
    return data;
  }
}

class Reviews {
  List<Items>? items;
  Pagination? pagination;

  Reviews({this.items, this.pagination});

  Reviews.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class Items {
  int? id;
  User? user;
  Session? session;
  Null? tag;
  int? rating;
  String? feedback;
  String? date;

  Items({
    this.id,
    this.user,
    this.session,
    this.tag,
    this.rating,
    this.feedback,
    this.date,
  });

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    session = json['session'] != null
        ? new Session.fromJson(json['session'])
        : null;
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

class Pagination {
  int? page;
  int? perPage;
  int? total;
  int? lastPage;

  Pagination({this.page, this.perPage, this.total, this.lastPage});

  Pagination.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    perPage = json['per_page'];
    total = json['total'];
    lastPage = json['last_page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['per_page'] = this.perPage;
    data['total'] = this.total;
    data['last_page'] = this.lastPage;
    return data;
  }
}

class AppliedFilters {
  List<dynamic>? stars;
  String? time;
  dynamic? from;
  dynamic? to;

  AppliedFilters({this.stars, this.time, this.from, this.to});

  AppliedFilters.fromJson(Map<String, dynamic> json) {
    // if (json['stars'] != null) {
    //   stars = <Null>[];
    //   json['stars'].forEach((v) {
    //     stars!.add(new Null.fromJson(v));
    //   });
    // }
    time = json['time'];
    from = json['from'];
    to = json['to'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.stars != null) {
      data['stars'] = this.stars!.map((v) => v.toJson()).toList();
    }
    data['time'] = this.time;
    data['from'] = this.from;
    data['to'] = this.to;
    return data;
  }
}
