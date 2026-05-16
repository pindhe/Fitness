# dataconnect_generated SDK

## Installation
```sh
flutter pub get firebase_data_connect
flutterfire configure
```
For more information, see [Flutter for Firebase installation documentation](https://firebase.google.com/docs/data-connect/flutter-sdk#use-core).

## Data Connect instance
Each connector creates a static class, with an instance of the `DataConnect` class that can be used to connect to your Data Connect backend and call operations.

### Connecting to the emulator

```dart
String host = 'localhost'; // or your host name
int port = 9399; // or your port number
ExampleConnector.instance.dataConnect.useDataConnectEmulator(host, port);
```

You can also call queries and mutations by using the connector class.
## Queries

### ListMovies
#### Required Arguments
```dart
// No required arguments
ExampleConnector.instance.listMovies().execute();
```



#### Return Type
`execute()` returns a `QueryResult<ListMoviesData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.listMovies();
ListMoviesData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = ExampleConnector.instance.listMovies().ref();
ref.execute();

ref.subscribe(...);
```


### ListUsers
#### Required Arguments
```dart
// No required arguments
ExampleConnector.instance.listUsers().execute();
```



#### Return Type
`execute()` returns a `QueryResult<ListUsersData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.listUsers();
ListUsersData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = ExampleConnector.instance.listUsers().ref();
ref.execute();

ref.subscribe(...);
```


### ListUserReviews
#### Required Arguments
```dart
// No required arguments
ExampleConnector.instance.listUserReviews().execute();
```



#### Return Type
`execute()` returns a `QueryResult<ListUserReviewsData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.listUserReviews();
ListUserReviewsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = ExampleConnector.instance.listUserReviews().ref();
ref.execute();

ref.subscribe(...);
```


### GetMovieById
#### Required Arguments
```dart
String id = ...;
ExampleConnector.instance.getMovieById(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetMovieByIdData, GetMovieByIdVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getMovieById(
  id: id,
);
GetMovieByIdData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = ExampleConnector.instance.getMovieById(
  id: id,
).ref();
ref.execute();

ref.subscribe(...);
```


### SearchMovie
#### Required Arguments
```dart
// No required arguments
ExampleConnector.instance.searchMovie().execute();
```

#### Optional Arguments
We return a builder for each query. For SearchMovie, we created `SearchMovieBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class SearchMovieVariablesBuilder {
  ...
 
  SearchMovieVariablesBuilder titleInput(String? t) {
   _titleInput.value = t;
   return this;
  }
  SearchMovieVariablesBuilder genre(String? t) {
   _genre.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.searchMovie()
.titleInput(titleInput)
.genre(genre)
.execute();
```

#### Return Type
`execute()` returns a `QueryResult<SearchMovieData, SearchMovieVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.searchMovie();
SearchMovieData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = ExampleConnector.instance.searchMovie().ref();
ref.execute();

ref.subscribe(...);
```

## Mutations

### CreateMovie
#### Required Arguments
```dart
String title = ...;
String genre = ...;
String imageUrl = ...;
ExampleConnector.instance.createMovie(
  title: title,
  genre: genre,
  imageUrl: imageUrl,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<CreateMovieData, CreateMovieVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.createMovie(
  title: title,
  genre: genre,
  imageUrl: imageUrl,
);
CreateMovieData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String title = ...;
String genre = ...;
String imageUrl = ...;

final ref = ExampleConnector.instance.createMovie(
  title: title,
  genre: genre,
  imageUrl: imageUrl,
).ref();
ref.execute();
```


### UpsertUser
#### Required Arguments
```dart
String username = ...;
ExampleConnector.instance.upsertUser(
  username: username,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<UpsertUserData, UpsertUserVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.upsertUser(
  username: username,
);
UpsertUserData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String username = ...;

final ref = ExampleConnector.instance.upsertUser(
  username: username,
).ref();
ref.execute();
```


### AddReview
#### Required Arguments
```dart
String movieId = ...;
int rating = ...;
String reviewText = ...;
ExampleConnector.instance.addReview(
  movieId: movieId,
  rating: rating,
  reviewText: reviewText,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<AddReviewData, AddReviewVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.addReview(
  movieId: movieId,
  rating: rating,
  reviewText: reviewText,
);
AddReviewData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String movieId = ...;
int rating = ...;
String reviewText = ...;

final ref = ExampleConnector.instance.addReview(
  movieId: movieId,
  rating: rating,
  reviewText: reviewText,
).ref();
ref.execute();
```


### DeleteReview
#### Required Arguments
```dart
String movieId = ...;
ExampleConnector.instance.deleteReview(
  movieId: movieId,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<DeleteReviewData, DeleteReviewVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.deleteReview(
  movieId: movieId,
);
DeleteReviewData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String movieId = ...;

final ref = ExampleConnector.instance.deleteReview(
  movieId: movieId,
).ref();
ref.execute();
```

