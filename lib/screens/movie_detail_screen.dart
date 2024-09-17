import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../models/movie.dart';

// Screen to display details of a movie
class MovieDetailScreen extends StatelessWidget {
  final Movie movie; // The movie to display details of

  // Constructor for MovieDetailScreen
  MovieDetailScreen({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // Helper function to build rating stars based on the given rating
    List<Widget> _buildRatingStars(double rating) {
      List<Widget> stars = [];
      for (int i = 1; i <= 5; i++) {
        stars.add(Icon(i <= rating ? Icons.star : Icons.star_border, color: Colors.amber));
      }
      return stars;
    }

    // Content of the screen
    Widget content = SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: AspectRatio(
              aspectRatio: 3 / 2,
              child: Image.network(movie.posterPath, fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Image.asset('assets/images/noimage.png', fit: BoxFit.contain),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(movie.title, style: Theme.of(context).textTheme.headline4),
                SizedBox(height: 8),
                Row(children: _buildRatingStars(movie.rating), mainAxisAlignment: MainAxisAlignment.start),
                SizedBox(height: 8),
                Text(movie.overview, style: Theme.of(context).textTheme.subtitle1),
              ],
            ),
          ),
        ],
      ),
    );

    // Determine the platform and return appropriate UI
    if (kIsWeb) {
      // Display scaffold for web platform
      return Scaffold(
        appBar: AppBar(title: Text(movie.title)),
        body: content,
      );
    }

    // For mobile platforms
    final bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    return isIOS ? CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text(movie.title)),
      child: SafeArea(child: content),
    ) : Scaffold(
      appBar: AppBar(title: Text(movie.title)),
      body: content,
    );
  }
}
