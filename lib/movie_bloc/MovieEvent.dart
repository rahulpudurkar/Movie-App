// Abstract class representing events that can occur in the movie bloc
abstract class MovieEvent {}

// Event class for fetching movies
class FetchMovies extends MovieEvent {}

// Event class for deleting a movie by its title
class DeleteMovieByTitle extends MovieEvent {
  final String title; // Title of the movie to be deleted

  // Constructor for DeleteMovieByTitle event
  DeleteMovieByTitle(this.title);
}
