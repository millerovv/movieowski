import 'package:equatable/equatable.dart';

abstract class BaseMoviesResponse {
  List<Movie> movies;
  int totalPages;
  int page;
  Dates dates;
  int totalResults;

  BaseMoviesResponse({this.movies, this.totalPages, this.page, this.dates, this.totalResults});
}

class Movie extends Equatable {
  int id;
  String title;
  String posterPath;
  double voteAverage;
  int voteCount;
  String releaseDate;
  List<int> genreIds;
  bool adult;
  double popularity;
  String overview;
  String originalTitle;
  String originalLanguage;
  String backdropPath;
  bool video;

  Movie(
      this.id,
      this.title,
      this.posterPath,
      this.voteAverage,
      this.voteCount,
      this.releaseDate,
      this.genreIds,
      this.adult,
      this.popularity,
      this.overview,
      this.originalTitle,
      this.originalLanguage,
      this.backdropPath,
      this.video);

  Movie.fromJson(Map<String, dynamic> json) {
    posterPath = (json['poster_path'] == null) ? '' : json['poster_path'];
    adult = json['adult'];
    overview = json['overview'];
    releaseDate = json['release_date'];
    genreIds = json['genre_ids'].cast<int>();
    id = json['id'];
    originalTitle = json['original_title'];
    originalLanguage = json['original_language'];
    title = json['title'];
    backdropPath = json['backdrop_path'];
    var popularityDynamic = json['popularity'];
    popularity = (popularityDynamic is int) ? popularityDynamic.toDouble() : popularityDynamic;
    voteCount = json['vote_count'];
    video = json['video'];
    var voteAverageDynamic = json['vote_average'];
    voteAverage = (voteAverageDynamic is int) ? voteAverageDynamic.toDouble() : voteAverageDynamic;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['poster_path'] = this.posterPath;
    data['adult'] = this.adult;
    data['overview'] = this.overview;
    data['release_date'] = this.releaseDate;
    data['genre_ids'] = this.genreIds;
    data['id'] = this.id;
    data['original_title'] = this.originalTitle;
    data['original_language'] = this.originalLanguage;
    data['title'] = this.title;
    data['backdrop_path'] = this.backdropPath;
    data['popularity'] = this.popularity;
    data['vote_count'] = this.voteCount;
    data['video'] = this.video;
    data['vote_average'] = this.voteAverage;
    return data;
  }
}

class Dates {
  String maximum;
  String minimum;

  Dates({this.maximum, this.minimum});

  Dates.fromJson(Map<String, dynamic> json) {
    maximum = json['maximum'];
    minimum = json['minimum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['maximum'] = this.maximum;
    data['minimum'] = this.minimum;
    return data;
  }
}