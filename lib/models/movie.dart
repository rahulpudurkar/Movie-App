// Define a Movie model class to hold information for each movie.
class Movie {
  // Attributes that each movie will have.
  final int id;
  final String title;
  final String posterPath;
  final String overview;
  final double rating;

  // Constructor to initialize the Movie object.
  Movie({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.overview,
    required this.rating,
  });

  // Factory constructor to create a new Movie instance from a map structure.
  factory Movie.fromJson(Map<String, dynamic> json) {
    // Check if posterPath is not null, if null, use a default image asset.
    String resolvedPosterPath = json['posterPath'] != null
        ? 'https://image.tmdb.org/t/p/w500${json['posterPath']}'
        : 'assets/images/noimage.png'; // Placeholder if the poster path is null.

    // Create a new Movie instance with values from the JSON structure.
    return Movie(
      id: json['id'] as int? ?? 0, // Default to 0 if id is not provided.
      title: json['title'] as String? ?? 'Unknown', // Default to 'Unknown' if title is not provided.
      posterPath: resolvedPosterPath,
      overview: json['overview'] as String? ?? 'No description provided.', // Default description if not provided.
      rating: (json['vote_average'] as num?)?.toDouble() ?? 0.0, // Convert to double, default to 0.0 if not provided.
    );
  }

  // Method to convert a Movie instance into a JSON map structure.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'posterPath': posterPath,
      'overview': overview,
      'rating': rating,
    };
  }
}
