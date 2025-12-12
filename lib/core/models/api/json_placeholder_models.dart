

class ApiUser {
  final int id;
  final String name;
  final String username;
  final String email;
  final ApiAddress? address;
  final String? phone;
  final String? website;
  final ApiCompany? company;

  const ApiUser({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    this.address,
    this.phone,
    this.website,
    this.company,
  });

  factory ApiUser.fromJson(Map<String, dynamic> json) {
    return ApiUser(
      id: json['id'] as int,
      name: json['name'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      address: json['address'] != null
          ? ApiAddress.fromJson(json['address'] as Map<String, dynamic>)
          : null,
      phone: json['phone'] as String?,
      website: json['website'] as String?,
      company: json['company'] != null
          ? ApiCompany.fromJson(json['company'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'address': address?.toJson(),
      'phone': phone,
      'website': website,
      'company': company?.toJson(),
    };
  }
}

class ApiAddress {
  final String street;
  final String suite;
  final String city;
  final String zipcode;
  final ApiGeo? geo;

  const ApiAddress({
    required this.street,
    required this.suite,
    required this.city,
    required this.zipcode,
    this.geo,
  });

  factory ApiAddress.fromJson(Map<String, dynamic> json) {
    return ApiAddress(
      street: json['street'] as String,
      suite: json['suite'] as String,
      city: json['city'] as String,
      zipcode: json['zipcode'] as String,
      geo: json['geo'] != null
          ? ApiGeo.fromJson(json['geo'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'suite': suite,
      'city': city,
      'zipcode': zipcode,
      'geo': geo?.toJson(),
    };
  }

  String get fullAddress => '$city, $street, $suite';
}

class ApiGeo {
  final String lat;
  final String lng;

  const ApiGeo({required this.lat, required this.lng});

  factory ApiGeo.fromJson(Map<String, dynamic> json) {
    return ApiGeo(
      lat: json['lat'] as String,
      lng: json['lng'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'lat': lat, 'lng': lng};
  }
}

class ApiCompany {
  final String name;
  final String catchPhrase;
  final String bs;

  const ApiCompany({
    required this.name,
    required this.catchPhrase,
    required this.bs,
  });

  factory ApiCompany.fromJson(Map<String, dynamic> json) {
    return ApiCompany(
      name: json['name'] as String,
      catchPhrase: json['catchPhrase'] as String,
      bs: json['bs'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'catchPhrase': catchPhrase,
      'bs': bs,
    };
  }
}

class ApiPost {
  final int userId;
  final int id;
  final String title;
  final String body;

  const ApiPost({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  factory ApiPost.fromJson(Map<String, dynamic> json) {
    return ApiPost(
      userId: json['userId'] as int,
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      'body': body,
    };
  }
}

class ApiComment {
  final int postId;
  final int id;
  final String name;
  final String email;
  final String body;

  const ApiComment({
    required this.postId,
    required this.id,
    required this.name,
    required this.email,
    required this.body,
  });

  factory ApiComment.fromJson(Map<String, dynamic> json) {
    return ApiComment(
      postId: json['postId'] as int,
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      body: json['body'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'id': id,
      'name': name,
      'email': email,
      'body': body,
    };
  }
}
