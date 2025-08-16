class ExclusiveservicedetailsModel {
  final bool? status;
  final Data? data;
  final String? message;

  const ExclusiveservicedetailsModel({this.status, this.data, this.message});

  factory ExclusiveservicedetailsModel.fromJson(Map<String, dynamic> json) {
    return ExclusiveservicedetailsModel(
      status: json['status'] as bool?,
      message: json['message'] as String?, // <— was missing
      data: json['data'] != null
          ? Data.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message, // <— was missing
      if (data != null) 'data': data!.toJson(),
    };
  }
}

class Data {
  final int? id;
  final String? name;
  final String? description;
  final String? imageUrl;
  final String? createdAt;
  final String? updatedAt;

  const Data({
    this.id,
    this.name,
    this.description,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    // id may come as int or string
    final dynamic rawId = json['id'];
    final int? parsedId =
    rawId is int ? rawId : (rawId is String ? int.tryParse(rawId) : null);

    return Data(
      id: parsedId,
      name: json['name'] as String?,
      description: json['description'] as String?,
      // accept both snake_case and camelCase keys
      imageUrl: (json['image_url'] ?? json['imageUrl']) as String?,
      createdAt: (json['created_at'] ?? json['createdAt']) as String?,
      updatedAt: (json['updated_at'] ?? json['updatedAt']) as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
