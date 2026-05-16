part of 'generated.dart';

class SearchMovieVariablesBuilder {
  Optional<String> _titleInput = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _genre = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;
  SearchMovieVariablesBuilder titleInput(String? t) {
   _titleInput.value = t;
   return this;
  }
  SearchMovieVariablesBuilder genre(String? t) {
   _genre.value = t;
   return this;
  }

  SearchMovieVariablesBuilder(this._dataConnect, );
  Deserializer<SearchMovieData> dataDeserializer = (dynamic json)  => SearchMovieData.fromJson(jsonDecode(json));
  Serializer<SearchMovieVariables> varsSerializer = (SearchMovieVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<SearchMovieData, SearchMovieVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<SearchMovieData, SearchMovieVariables> ref() {
    SearchMovieVariables vars= SearchMovieVariables(titleInput: _titleInput,genre: _genre,);
    return _dataConnect.query("SearchMovie", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class SearchMovieMovies {
  final String id;
  final String title;
  final String? genre;
  final String imageUrl;
  SearchMovieMovies.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  title = nativeFromJson<String>(json['title']),
  genre = json['genre'] == null ? null : nativeFromJson<String>(json['genre']),
  imageUrl = nativeFromJson<String>(json['imageUrl']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final SearchMovieMovies otherTyped = other as SearchMovieMovies;
    return id == otherTyped.id && 
    title == otherTyped.title && 
    genre == otherTyped.genre && 
    imageUrl == otherTyped.imageUrl;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, title.hashCode, genre.hashCode, imageUrl.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['title'] = nativeToJson<String>(title);
    if (genre != null) {
      json['genre'] = nativeToJson<String?>(genre);
    }
    json['imageUrl'] = nativeToJson<String>(imageUrl);
    return json;
  }

  SearchMovieMovies({
    required this.id,
    required this.title,
    this.genre,
    required this.imageUrl,
  });
}

@immutable
class SearchMovieData {
  final List<SearchMovieMovies> movies;
  SearchMovieData.fromJson(dynamic json):
  
  movies = (json['movies'] as List<dynamic>)
        .map((e) => SearchMovieMovies.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final SearchMovieData otherTyped = other as SearchMovieData;
    return movies == otherTyped.movies;
    
  }
  @override
  int get hashCode => movies.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['movies'] = movies.map((e) => e.toJson()).toList();
    return json;
  }

  SearchMovieData({
    required this.movies,
  });
}

@immutable
class SearchMovieVariables {
  late final Optional<String>titleInput;
  late final Optional<String>genre;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  SearchMovieVariables.fromJson(Map<String, dynamic> json) {
  
  
    titleInput = Optional.optional(nativeFromJson, nativeToJson);
    titleInput.value = json['titleInput'] == null ? null : nativeFromJson<String>(json['titleInput']);
  
  
    genre = Optional.optional(nativeFromJson, nativeToJson);
    genre.value = json['genre'] == null ? null : nativeFromJson<String>(json['genre']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final SearchMovieVariables otherTyped = other as SearchMovieVariables;
    return titleInput == otherTyped.titleInput && 
    genre == otherTyped.genre;
    
  }
  @override
  int get hashCode => Object.hashAll([titleInput.hashCode, genre.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if(titleInput.state == OptionalState.set) {
      json['titleInput'] = titleInput.toJson();
    }
    if(genre.state == OptionalState.set) {
      json['genre'] = genre.toJson();
    }
    return json;
  }

  SearchMovieVariables({
    required this.titleInput,
    required this.genre,
  });
}

