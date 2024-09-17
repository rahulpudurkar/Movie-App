import 'dart:developer'; // Importing developer module for logging
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/movie.dart';
import '../services/movie_service.dart';

// Provider class for managing movie data
class MovieProvider with ChangeNotifier {
  List<Movie> _movies = []; // List of movies
  bool _isFetching = false; // Flag indicating whether data is being fetched
  String _error = ''; // Error message if fetching fails
  final MovieService _movieService = MovieService(); // Movie service for API interaction

  // Getter for movies
  List<Movie> get movies => _movies;

  // Getter for fetching status
  bool get isFetching => _isFetching;

  // Getter for error message
  String get error => _error;

  // Constructor
  MovieProvider() {
    loadMovies(); // Load movies on initialization
  }

  // Method to load movies from the database
  Future<void> loadMovies() async {
    _isFetching = true; // Set fetching flag to true
    _error = ''; // Reset error message
    notifyListeners(); // Notify listeners about data change
    try {
      _movies = await _movieService.fetchMoviesFromDatabase(); // Fetch movies
    } catch (e) {
      _error = 'Failed to load movies: $e'; // Set error message if fetching fails
    } finally {
      _isFetching = false; // Set fetching flag to false
      notifyListeners(); // Notify listeners about data change
    }
  }

  // Method to delete a movie by title
  Future<void> deleteMovieByTitle(int index, BuildContext context) async {
    final movieTitle = _movies[index].title; // Get movie title
    final success = await _movieService.deleteMovieByTitle(movieTitle); // Delete movie
    if (success) {
      _movies.removeAt(index); // Remove movie from list
      notifyListeners(); // Notify listeners about data change
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Movie deleted successfully')), // Show success message
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete movie')), // Show failure message
      );
    }
  }
}
