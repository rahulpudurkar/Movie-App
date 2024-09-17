import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';
import './MovieState.dart';
import './MovieEvent.dart';

// Define a BLoC class that extends Bloc<MovieEvent, MovieState>
class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final MovieService movieService; // Service to interact with movie data

  // Constructor for the MovieBloc class
  MovieBloc({required this.movieService}) : super(MovieInitial()) {
    // Define event handlers for different events
    on<FetchMovies>(_onFetchMovies);
    on<DeleteMovieByTitle>(_onDeleteMovieByTitle);
  }

  // Event handler for FetchMovies event
  Future<void> _onFetchMovies(FetchMovies event, Emitter<MovieState> emit) async {
    emit(MoviesLoadInProgress()); // Emit a loading state
    try {
      final movies = await movieService.fetchMoviesFromDatabase(forceRefresh: true); // Fetch movies from the service
      final uniqueMovies = _ensureUniqueMovies(movies); // Remove duplicates from fetched movies
      emit(MoviesLoadSuccess(uniqueMovies)); // Emit success state with fetched movies
    } catch (error) {
      emit(MoviesLoadFailure(error.toString())); // Emit failure state if an error occurs
    }
  }

  // Event handler for DeleteMovieByTitle event
  Future<void> _onDeleteMovieByTitle(DeleteMovieByTitle event, Emitter<MovieState> emit) async {
    try {
      final success = await movieService.deleteMovieByTitle(event.title); // Attempt to delete movie by title
      if (success) {
        add(FetchMovies()); // If successful, trigger FetchMovies event to reload movie list
      } else {
        emit(MoviesDeletionFailure("Failed to delete the movie")); // Emit failure state if deletion fails
      }
    } catch (error) {
      emit(MoviesLoadFailure(error.toString())); // Emit failure state if an error occurs
    }
  }

  // Helper function to ensure uniqueness of movies
  List<Movie> _ensureUniqueMovies(List<Movie> newMovies) {
    return newMovies.toSet().toList(); // Convert list to set to remove duplicates, then convert back to list
  }
}
