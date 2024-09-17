import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

// Service class to interact with movie data
class MovieService {
  // API key and base URL for The Movie Database API
  static const _apiKey = 'ac65dbeb5db8a7fc4848dde915a0b42c';
  static const _baseUrl = 'https://api.themoviedb.org/3';

  // Backend URL for local database
  final String _backendUrl = 'http://localhost:3000/movies';

  // Cached list of movies to avoid unnecessary API calls
  List<Movie> _cachedMovies = [];

  // Fetch movies from the local database
  Future<List<Movie>> fetchMoviesFromDatabase({bool forceRefresh = false}) async {
    if (forceRefresh || _cachedMovies.isEmpty) {
      // Perform API call if cache is empty or forceRefresh is requested
      final response = await http.get(Uri.parse(_backendUrl));
      if (response.statusCode == 200) {
        // Decode response and map JSON data to list of Movie objects
        final List<dynamic> movieJsonList = json.decode(response.body) as List<dynamic>;
        _cachedMovies = movieJsonList.map((movieJson) => Movie.fromJson(movieJson)).toList();
      } else {
        // Throw exception if API call fails
        throw Exception('Failed to load movies from the database');
      }
    }
    return _cachedMovies; // Return cached movies
  }

  // Delete a movie from the local database by its title
  Future<bool> deleteMovieByTitle(String title) async {
    try {
      // Send HTTP DELETE request to delete movie by title
      final response = await http.delete(
        Uri.parse('$_backendUrl/deleteByTitle'),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({'title': title}),
      );

      if (response.statusCode == 200) {
        // If deletion is successful, remove the movie from the cached list
        _cachedMovies.removeWhere((movie) => movie.title == title);
        return true; // Return true to indicate successful deletion
      }
      return false; // Return false if deletion fails
    } catch (e) {
      print('Error deleting movie: $e'); // Print error if an exception occurs
      return false; // Return false if an exception occurs during deletion
    }
  }
}
