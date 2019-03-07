import 'package:movieowski/src/models/base_movies_response.dart';

class NowPlayingMoviesResponseRoot extends BaseMoviesResponse {
	int page;
	List<NowPlayingMovie> results;
	Dates dates;
	int totalPages;
	int totalResults;

	NowPlayingMoviesResponseRoot(
			{this.page,
				this.results,
				this.dates,
				this.totalPages,
				this.totalResults});

	NowPlayingMoviesResponseRoot.fromJson(Map<String, dynamic> json) {
		page = json['page'];
		if (json['results'] != null) {
			results = new List<NowPlayingMovie>();
			json['results'].forEach((v) {
				results.add(new NowPlayingMovie.fromJson(v));
			});
		}
		dates = json['dates'] != null ? new Dates.fromJson(json['dates']) : null;
		totalPages = json['total_pages'];
		totalResults = json['total_results'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['page'] = this.page;
		if (this.results != null) {
			data['results'] = this.results.map((v) => v.toJson()).toList();
		}
		if (this.dates != null) {
			data['dates'] = this.dates.toJson();
		}
		data['total_pages'] = this.totalPages;
		data['total_results'] = this.totalResults;
		return data;
	}
}

class NowPlayingMovie extends BaseResponseMovie {
	String posterPath;
	bool adult;
	String overview;
	String releaseDate;
	List<int> genreIds;
	int id;
	String originalTitle;
	String originalLanguage;
	String title;
	String backdropPath;
	double popularity;
	int voteCount;
	bool video;
	double voteAverage;

	NowPlayingMovie(
			{this.posterPath,
				this.adult,
				this.overview,
				this.releaseDate,
				this.genreIds,
				this.id,
				this.originalTitle,
				this.originalLanguage,
				this.title,
				this.backdropPath,
				this.popularity,
				this.voteCount,
				this.video,
				this.voteAverage});

	NowPlayingMovie.fromJson(Map<String, dynamic> json) {
		posterPath = json['poster_path'];
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