part of 'generated.dart';

class GetMovieByIdVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  GetMovieByIdVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<GetMovieByIdData> dataDeserializer = (dynamic json)  => GetMovieByIdData.fromJson(jsonDecode(json));
  Serializer<GetMovieByIdVariables> varsSerializer = (GetMovieByIdVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetMovieByIdData, GetMovieByIdVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetMovieByIdData, GetMovieByIdVariables> ref() {
    GetMovieByIdVariables vars= GetMovieByIdVariables(id: id,);
    return _dataConnect.query("GetMovieById", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetMovieByIdMovie {
  final String id;
  final String title;
  final String imageUrl;
  final String? genre;
  final GetMovieByIdMovieMetadata? metadata;
  final List<GetMovieByIdMovieReviews> reviews;
  GetMovieByIdMovie.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  title = nativeFromJson<String>(json['title']),
  imageUrl = nativeFromJson<String>(json['imageUrl']),
  genre = json['genre'] == null ? null : nativeFromJson<String>(json['genre']),
  metadata = json['metadata'] == null ? null : GetMovieByIdMovieMetadata.fromJson(json['metadata']),
  reviews = (json['reviews'] as List<dynamic>)
        .map((e) => GetMovieByIdMovieReviews.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMovieByIdMovie otherTyped = other as GetMovieByIdMovie;
    return id == otherTyped.id && 
    title == otherTyped.title && 
    imageUrl == otherTyped.imageUrl && 
    genre == otherTyped.genre && 
    metadata == otherTyped.metadata && 
    reviews == otherTyped.reviews;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, title.hashCode, imageUrl.hashCode, genre.hashCode, metadata.hashCode, reviews.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['title'] = nativeToJson<String>(title);
    json['imageUrl'] = nativeToJson<String>(imageUrl);
    if (genre != null) {
      json['genre'] = nativeToJson<String?>(genre);
    }
    if (metadata != null) {
      json['metadata'] = metadata!.toJson();
    }
    json['reviews'] = reviews.map((e) => e.toJson()).toList();
    return json;
  }

  GetMovieByIdMovie({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.genre,
    this.metadata,
    required this.reviews,
  });
}

@immutable
class GetMovieByIdMovieMetadata {
  final double? rating;
  final int? releaseYear;
  final String? description;
  GetMovieByIdMovieMetadata.fromJson(dynamic json):
  
  rating = json['rating'] == null ? null : nativeFromJson<double>(json['rating']),
  releaseYear = json['releaseYear'] == null ? null : nativeFromJson<int>(json['releaseYear']),
  description = json['description'] == null ? null : nativeFromJson<String>(json['description']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMovieByIdMovieMetadata otherTyped = other as GetMovieByIdMovieMetadata;
    return rating == otherTyped.rating && 
    releaseYear == otherTyped.releaseYear && 
    description == otherTyped.description;
    
  }
  @override
  int get hashCode => Object.hashAll([rating.hashCode, releaseYear.hashCode, description.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (rating != null) {
      json['rating'] = nativeToJson<double?>(rating);
    }
    if (releaseYear != null) {
      json['releaseYear'] = nativeToJson<int?>(releaseYear);
    }
    if (description != null) {
      json['description'] = nativeToJson<String?>(description);
    }
    return json;
  }

  GetMovieByIdMovieMetadata({
    this.rating,
    this.releaseYear,
    this.description,
  });
}

@immutable
class GetMovieByIdMovieReviews {
  final String? reviewText;
  final DateTime reviewDate;
  final int? rating;
  final GetMovieByIdMovieReviewsUser user;
  GetMovieByIdMovieReviews.fromJson(dynamic json):
  
  reviewText = json['reviewText'] == null ? null : nativeFromJson<String>(json['reviewText']),
  reviewDate = nativeFromJson<DateTime>(json['reviewDate']),
  rating = json['rating'] == null ? null : nativeFromJson<int>(json['rating']),
  user = GetMovieByIdMovieReviewsUser.fromJson(json['user']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMovieByIdMovieReviews otherTyped = other as GetMovieByIdMovieReviews;
    return reviewText == otherTyped.reviewText && 
    reviewDate == otherTyped.reviewDate && 
    rating == otherTyped.rating && 
    user == otherTyped.user;
    
  }
  @override
  int get hashCode => Object.hashAll([reviewText.hashCode, reviewDate.hashCode, rating.hashCode, user.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (reviewText != null) {
      json['reviewText'] = nativeToJson<String?>(reviewText);
    }
    json['reviewDate'] = nativeToJson<DateTime>(reviewDate);
    if (rating != null) {
      json['rating'] = nativeToJson<int?>(rating);
    }
    json['user'] = user.toJson();
    return json;
  }

  GetMovieByIdMovieReviews({
    this.reviewText,
    required this.reviewDate,
    this.rating,
    required this.user,
  });
}

@immutable
class GetMovieByIdMovieReviewsUser {
  final String id;
  final String username;
  GetMovieByIdMovieReviewsUser.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  username = nativeFromJson<String>(json['username']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMovieByIdMovieReviewsUser otherTyped = other as GetMovieByIdMovieReviewsUser;
    return id == otherTyped.id && 
    username == otherTyped.username;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, username.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['username'] = nativeToJson<String>(username);
    return json;
  }

  GetMovieByIdMovieReviewsUser({
    required this.id,
    required this.username,
  });
}

@immutable
class GetMovieByIdData {
  final GetMovieByIdMovie? movie;
  GetMovieByIdData.fromJson(dynamic json):
  
  movie = json['movie'] == null ? null : GetMovieByIdMovie.fromJson(json['movie']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMovieByIdData otherTyped = other as GetMovieByIdData;
    return movie == otherTyped.movie;
    
  }
  @override
  int get hashCode => movie.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (movie != null) {
      json['movie'] = movie!.toJson();
    }
    return json;
  }

  GetMovieByIdData({
    this.movie,
  });
}

@immutable
class GetMovieByIdVariables {
  final String id;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetMovieByIdVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMovieByIdVariables otherTyped = other as GetMovieByIdVariables;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  GetMovieByIdVariables({
    required this.id,
  });
}

