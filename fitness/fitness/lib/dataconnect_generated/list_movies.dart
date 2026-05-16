part of 'generated.dart';

class ListMoviesVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  ListMoviesVariablesBuilder(this._dataConnect, );
  Deserializer<ListMoviesData> dataDeserializer = (dynamic json)  => ListMoviesData.fromJson(jsonDecode(json));
  
  Future<QueryResult<ListMoviesData, void>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<ListMoviesData, void> ref() {
    
    return _dataConnect.query("ListMovies", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class ListMoviesMovies {
  final String id;
  final String title;
  final String imageUrl;
  final String? genre;
  ListMoviesMovies.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  title = nativeFromJson<String>(json['title']),
  imageUrl = nativeFromJson<String>(json['imageUrl']),
  genre = json['genre'] == null ? null : nativeFromJson<String>(json['genre']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListMoviesMovies otherTyped = other as ListMoviesMovies;
    return id == otherTyped.id && 
    title == otherTyped.title && 
    imageUrl == otherTyped.imageUrl && 
    genre == otherTyped.genre;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, title.hashCode, imageUrl.hashCode, genre.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['title'] = nativeToJson<String>(title);
    json['imageUrl'] = nativeToJson<String>(imageUrl);
    if (genre != null) {
      json['genre'] = nativeToJson<String?>(genre);
    }
    return json;
  }

  ListMoviesMovies({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.genre,
  });
}

@immutable
class ListMoviesData {
  final List<ListMoviesMovies> movies;
  ListMoviesData.fromJson(dynamic json):
  
  movies = (json['movies'] as List<dynamic>)
        .map((e) => ListMoviesMovies.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListMoviesData otherTyped = other as ListMoviesData;
    return movies == otherTyped.movies;
    
  }
  @override
  int get hashCode => movies.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['movies'] = movies.map((e) => e.toJson()).toList();
    return json;
  }

  ListMoviesData({
    required this.movies,
  });
}

