part of 'generated.dart';

class AddReviewVariablesBuilder {
  String movieId;
  int rating;
  String reviewText;

  final FirebaseDataConnect _dataConnect;
  AddReviewVariablesBuilder(this._dataConnect, {required  this.movieId,required  this.rating,required  this.reviewText,});
  Deserializer<AddReviewData> dataDeserializer = (dynamic json)  => AddReviewData.fromJson(jsonDecode(json));
  Serializer<AddReviewVariables> varsSerializer = (AddReviewVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<AddReviewData, AddReviewVariables>> execute() {
    return ref().execute();
  }

  MutationRef<AddReviewData, AddReviewVariables> ref() {
    AddReviewVariables vars= AddReviewVariables(movieId: movieId,rating: rating,reviewText: reviewText,);
    return _dataConnect.mutation("AddReview", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class AddReviewReviewUpsert {
  final String userId;
  final String movieId;
  AddReviewReviewUpsert.fromJson(dynamic json):
  
  userId = nativeFromJson<String>(json['userId']),
  movieId = nativeFromJson<String>(json['movieId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AddReviewReviewUpsert otherTyped = other as AddReviewReviewUpsert;
    return userId == otherTyped.userId && 
    movieId == otherTyped.movieId;
    
  }
  @override
  int get hashCode => Object.hashAll([userId.hashCode, movieId.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['userId'] = nativeToJson<String>(userId);
    json['movieId'] = nativeToJson<String>(movieId);
    return json;
  }

  AddReviewReviewUpsert({
    required this.userId,
    required this.movieId,
  });
}

@immutable
class AddReviewData {
  final AddReviewReviewUpsert review_upsert;
  AddReviewData.fromJson(dynamic json):
  
  review_upsert = AddReviewReviewUpsert.fromJson(json['review_upsert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AddReviewData otherTyped = other as AddReviewData;
    return review_upsert == otherTyped.review_upsert;
    
  }
  @override
  int get hashCode => review_upsert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['review_upsert'] = review_upsert.toJson();
    return json;
  }

  AddReviewData({
    required this.review_upsert,
  });
}

@immutable
class AddReviewVariables {
  final String movieId;
  final int rating;
  final String reviewText;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  AddReviewVariables.fromJson(Map<String, dynamic> json):
  
  movieId = nativeFromJson<String>(json['movieId']),
  rating = nativeFromJson<int>(json['rating']),
  reviewText = nativeFromJson<String>(json['reviewText']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AddReviewVariables otherTyped = other as AddReviewVariables;
    return movieId == otherTyped.movieId && 
    rating == otherTyped.rating && 
    reviewText == otherTyped.reviewText;
    
  }
  @override
  int get hashCode => Object.hashAll([movieId.hashCode, rating.hashCode, reviewText.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['movieId'] = nativeToJson<String>(movieId);
    json['rating'] = nativeToJson<int>(rating);
    json['reviewText'] = nativeToJson<String>(reviewText);
    return json;
  }

  AddReviewVariables({
    required this.movieId,
    required this.rating,
    required this.reviewText,
  });
}

