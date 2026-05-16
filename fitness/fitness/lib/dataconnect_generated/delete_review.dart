part of 'generated.dart';

class DeleteReviewVariablesBuilder {
  String movieId;

  final FirebaseDataConnect _dataConnect;
  DeleteReviewVariablesBuilder(this._dataConnect, {required  this.movieId,});
  Deserializer<DeleteReviewData> dataDeserializer = (dynamic json)  => DeleteReviewData.fromJson(jsonDecode(json));
  Serializer<DeleteReviewVariables> varsSerializer = (DeleteReviewVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<DeleteReviewData, DeleteReviewVariables>> execute() {
    return ref().execute();
  }

  MutationRef<DeleteReviewData, DeleteReviewVariables> ref() {
    DeleteReviewVariables vars= DeleteReviewVariables(movieId: movieId,);
    return _dataConnect.mutation("DeleteReview", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class DeleteReviewReviewDelete {
  final String userId;
  final String movieId;
  DeleteReviewReviewDelete.fromJson(dynamic json):
  
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

    final DeleteReviewReviewDelete otherTyped = other as DeleteReviewReviewDelete;
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

  DeleteReviewReviewDelete({
    required this.userId,
    required this.movieId,
  });
}

@immutable
class DeleteReviewData {
  final DeleteReviewReviewDelete? review_delete;
  DeleteReviewData.fromJson(dynamic json):
  
  review_delete = json['review_delete'] == null ? null : DeleteReviewReviewDelete.fromJson(json['review_delete']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteReviewData otherTyped = other as DeleteReviewData;
    return review_delete == otherTyped.review_delete;
    
  }
  @override
  int get hashCode => review_delete.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (review_delete != null) {
      json['review_delete'] = review_delete!.toJson();
    }
    return json;
  }

  DeleteReviewData({
    this.review_delete,
  });
}

@immutable
class DeleteReviewVariables {
  final String movieId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  DeleteReviewVariables.fromJson(Map<String, dynamic> json):
  
  movieId = nativeFromJson<String>(json['movieId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteReviewVariables otherTyped = other as DeleteReviewVariables;
    return movieId == otherTyped.movieId;
    
  }
  @override
  int get hashCode => movieId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['movieId'] = nativeToJson<String>(movieId);
    return json;
  }

  DeleteReviewVariables({
    required this.movieId,
  });
}

