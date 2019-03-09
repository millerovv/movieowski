import 'package:movieowski/src/model/api/response/base_movies_response.dart';

class UpcomingMoviesResponseRoot extends BaseMoviesResponse {
	List<UpcomingMovie> results;
	int page;
	int totalResults;
	Dates dates;
	int totalPages;

	UpcomingMoviesResponseRoot(
			{this.results,
				this.page,
				this.totalResults,
				this.dates,
				this.totalPages});

	UpcomingMoviesResponseRoot.fromJson(Map<String, dynamic> json) {
		if (json['results'] != null) {
			results = new List<UpcomingMovie>();
			json['results'].forEach((v) {
				results.add(new UpcomingMovie.fromJson(v));
			});
		}
		page = json['page'];
		totalResults = json['total_results'];
		dates = json['dates'] != null ? new Dates.fromJson(json['dates']) : null;
		totalPages = json['total_pages'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		if (this.results != null) {
			data['results'] = this.results.map((v) => v.toJson()).toList();
		}
		data['page'] = this.page;
		data['total_results'] = this.totalResults;
		if (this.dates != null) {
			data['dates'] = this.dates.toJson();
		}
		data['total_pages'] = this.totalPages;
		return data;
	}
}

class UpcomingMovie extends BaseResponseMovie {
	int voteCount;
	int id;
	bool video;
	double voteAverage;
	String title;
	double popularity;
	String posterPath;
	String originalLanguage;
	String originalTitle;
	List<int> genreIds;
	String backdropPath;
	bool adult;
	String overview;
	String releaseDate;

	UpcomingMovie(
			{this.voteCount,
				this.id,
				this.video,
				this.voteAverage,
				this.title,
				this.popularity,
				this.posterPath,
				this.originalLanguage,
				this.originalTitle,
				this.genreIds,
				this.backdropPath,
				this.adult,
				this.overview,
				this.releaseDate});

	UpcomingMovie.fromJson(Map<String, dynamic> json) {
		voteCount = json['vote_count'];
		id = json['id'];
		video = json['video'];
		voteAverage = json['vote_average'].toDouble();
		title = json['title'];
		popularity = json['popularity'].toDouble();
		posterPath = json['poster_path'];
		originalLanguage = json['original_language'];
		originalTitle = json['original_title'];
		genreIds = json['genre_ids'].cast<int>();
		backdropPath = json['backdrop_path'];
		adult = json['adult'];
		overview = json['overview'];
		releaseDate = json['release_date'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['vote_count'] = this.voteCount;
		data['id'] = this.id;
		data['video'] = this.video;
		data['vote_average'] = this.voteAverage;
		data['title'] = this.title;
		data['popularity'] = this.popularity;
		data['poster_path'] = this.posterPath;
		data['original_language'] = this.originalLanguage;
		data['original_title'] = this.originalTitle;
		data['genre_ids'] = this.genreIds;
		data['backdrop_path'] = this.backdropPath;
		data['adult'] = this.adult;
		data['overview'] = this.overview;
		data['release_date'] = this.releaseDate;
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