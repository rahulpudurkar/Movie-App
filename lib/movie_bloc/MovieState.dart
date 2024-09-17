import '../models/movie.dart'; // Importing the movie model

// Abstract class representing different states of the movie bloc
abstract class MovieState {}

// Initial state of the movie bloc
class MovieInitial extends MovieState {}

// State indicating that movies are currently being loaded
class MoviesLoadInProgress extends MovieState {}

// State indicating successful loading of movies
class MoviesLoadSuccess extends MovieState {
  final List<Movie> movies; // List of movies loaded successfully

  // Constructor for MoviesLoadSuccess state
  MoviesLoadSuccess(this.movies);
}

// State indicating failure while loading movies
class MoviesLoadFailure extends MovieState {
  final String message; // Error message indicating the reason for failure

  // Constructor for MoviesLoadFailure state
  MoviesLoadFailure(this.message);
}

// State indicating failure while deleting a movie
class MoviesDeletionFailure extends MovieState {
  final String message; // Error message indicating the reason for deletion failure

  // Constructor for MoviesDeletionFailure state
  MoviesDeletionFailure(this.message);
}
