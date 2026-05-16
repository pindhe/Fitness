part of 'generated.dart';

class ListUserReviewsVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  ListUserReviewsVariablesBuilder(this._dataConnect, );
  Deserializer<ListUserReviewsData> dataDeserializer = (dynamic json)  => ListUserReviewsData.fromJson(jsonDecode(json));
  
  Future<QueryResult<ListUserReviewsData, void>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<ListUserReviewsData, void> ref() {
    
    return _dataConnect.query("ListUserReviews", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class ListUserReviewsUser {
  final String id;
  final String username;
  final List<ListUserReviewsUserReviews> reviews;
  ListUserReviewsUser.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  username = nativeFromJson<String>(json['username']),
  reviews = (json['reviews'] as List<dynamic>)
        .map((e) => ListUserReviewsUserReviews.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListUserReviewsUser otherTyped = other as ListUserReviewsUser;
    return id == otherTyped.id && 
    username == otherTyped.username && 
    reviews == otherTyped.reviews;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, username.hashCode, reviews.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['username'] = nativeToJson<String>(username);
    json['reviews'] = reviews.map((e) => e.toJson()).toList();
    return json;
  }

  ListUserReviewsUser({
    required this.id,
    required this.username,
    required this.reviews,
  });
}

@immutable
class ListUserReviewsUserReviews {
  final int? rating;
  final DateTime reviewDate;
  final String? reviewText;
  final ListUserReviewsUserReviewsMovie movie;
  ListUserReviewsUserReviews.fromJson(dynamic json):
  
  rating = json['rating'] == null ? null : nativeFromJson<int>(json['rating']),
  reviewDate = nativeFromJson<DateTime>(json['reviewDate']),
  reviewText = json['reviewText'] == null ? null : nativeFromJson<String>(json['reviewText']),
  movie = ListUserReviewsUserReviewsMovie.fromJson(json['movie']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListUserReviewsUserReviews otherTyped = other as ListUserReviewsUserReviews;
    return rating == otherTyped.rating && 
    reviewDate == otherTyped.reviewDate && 
    reviewText == otherTyped.reviewText && 
    movie == otherTyped.movie;
    
  }
  @override
  int get hashCode => Object.hashAll([rating.hashCode, reviewDate.hashCode, reviewText.hashCode, movie.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (rating != null) {
      json['rating'] = nativeToJson<int?>(rating);
    }
    json['reviewDate'] = nativeToJson<DateTime>(reviewDate);
    if (reviewText != null) {
      json['reviewText'] = nativeToJson<String?>(reviewText);
    }
    json['movie'] = movie.toJson();
    return json;
  }

  ListUserReviewsUserReviews({
    this.rating,
    required this.reviewDate,
    this.reviewText,
    required this.movie,
  });
}

@immutable
class ListUserReviewsUserReviewsMovie {
  final String id;
  final String title;
  ListUserReviewsUserReviewsMovie.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  title = nativeFromJson<String>(json['title']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListUserReviewsUserReviewsMovie otherTyped = other as ListUserReviewsUserReviewsMovie;
    return id == otherTyped.id && 
    title == otherTyped.title;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, title.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['title'] = nativeToJson<String>(title);
    return json;
  }

  ListUserReviewsUserReviewsMovie({
    required this.id,
    required this.title,
  });
}

@immutable
class ListUserReviewsData {
  final ListUserReviewsUser? user;
  ListUserReviewsData.fromJson(dynamic json):
  
  user = json['user'] == null ? null : ListUserReviewsUser.fromJson(json['user']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListUserReviewsData otherTyped = other as ListUserReviewsData;
    return user == otherTyped.user;
    
  }
  @override
  int get hashCode => user.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (user != null) {
      json['user'] = user!.toJson();
    }
    return json;
  }

  ListUserReviewsData({
    this.user,
  });
}

