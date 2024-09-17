import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../screens/movie_detail_screen.dart';

// Search delegate for movie search
class MovieSearchDelegate extends SearchDelegate<Movie?> {
  final List<Movie> movies; // List of movies to search from

  // Constructor
  MovieSearchDelegate({required this.movies});

  // Build action buttons for search field
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      // Clear query button
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = ''; // Clear query
            showSuggestions(context); // Show suggestions
          },
        ),
    ];
  }

  // Build leading icon for search field
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // Close search delegate
      },
    );
  }

  // Build search results
  @override
  Widget buildResults(BuildContext context) {
    // Filter movies based on query
    final results = movies.where((movie) {
      return movie.title.toLowerCase().contains(query.toLowerCase());
    }).toList();

    // Build grid view for search results
    return _buildMovieGridView(results, context);
  }

  // Build search suggestions
  @override
  Widget buildSuggestions(BuildContext context) {
    // Filter movies based on query for suggestions
    final suggestions = movies.where((movie) {
      return movie.title.toLowerCase().contains(query.toLowerCase());
    }).toList();

    // Build grid view for search suggestions
    return _buildMovieGridView(suggestions, context);
  }

  // Build grid view for movies
  Widget _buildMovieGridView(List<Movie> movies, BuildContext context) {
    // If no movies found, display a message
    if (movies.isEmpty) {
      return Center(
        child: Text(
          'No Results Found.',
          style: Theme.of(context).textTheme.subtitle1,
        ),
      );
    }

    // Build grid view for movies
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.6,
      ),
      itemCount: movies.length,
      itemBuilder: (BuildContext context, int index) {
        final movie = movies[index];
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MovieDetailScreen(movie: movie),
            ),
          ),
          child: GridTile(
            child: movie.posterPath.isNotEmpty
                ? Image.network(movie.posterPath, fit: BoxFit.cover)
                : const Placeholder(), // Placeholder if no poster available
            footer: GridTileBar(
              backgroundColor: Colors.black45,
              title: Text(
                movie.title,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
    );
  }
}
