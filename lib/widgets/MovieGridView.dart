import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../screens/movie_detail_screen.dart';

// Widget representing an item in the movie grid
class MovieGridItem extends StatelessWidget {
  final Movie movie; // The movie associated with this grid item

  // Constructor
  const MovieGridItem({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // GestureDetector to handle tap events
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => MovieDetailScreen(movie: movie)), // Navigate to movie detail screen on tap
      ),
      child: Card(
        elevation: 4.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Image.network(
                movie.posterPath, // Display movie poster
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  'assets/images/placeholder.png', // Placeholder image if poster not available
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                movie.title, // Display movie title
                style: Theme.of(context).textTheme.headline6,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
