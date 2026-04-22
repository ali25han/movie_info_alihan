class Movie {
  final String title;
  final String year;
  final String genre;
  final String imdbRating;
  final String poster;
  final String plot;
  final String director;
  final String actors;

  Movie({
    required this.title,
    required this.year,
    required this.genre,
    required this.imdbRating,
    required this.poster,
    required this.plot,
    required this.director,
    required this.actors,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['Title'] ?? 'No title',
      year: json['Year'] ?? 'No year',
      genre: json['Genre'] ?? 'No genre',
      imdbRating: json['imdbRating'] ?? 'N/A',
      poster: json['Poster'] ?? '',
      plot: json['Plot'] ?? 'No description',
      director: json['Director'] ?? 'Unknown',
      actors: json['Actors'] ?? 'Unknown',
    );
  }
}
