import 'package:movieowski/src/model/api/response/base_movies_response.dart';

class TrendingMoviesResponseRoot extends BaseMoviesResponse {
	int page;
	List<TrendingMovie> results;
	int totalPages;
	int totalResults;

	TrendingMoviesResponseRoot({this.page, this.results, this.totalPages, this.totalResults});

	TrendingMoviesResponseRoot.fromJson(Map<String, dynamic> json) {
		page = json['page'];
		if (json['results'] != null) {
			results = new List<TrendingMovie>();
			json['results'].forEach((v) {
				results.add(new TrendingMovie.fromJson(v));
			});
		}
		totalPages = json['total_pages'];
		totalResults = json['total_results'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['page'] = this.page;
		if (this.results != null) {
			data['results'] = this.results.map((v) => v.toJson()).toList();
		}
		data['total_pages'] = this.totalPages;
		data['total_results'] = this.totalResults;
		return data;
	}
}

class TrendingMovie extends BaseResponseMovie {
	bool adult;
	String backdropPath;
	List<int> genreIds;
	int id;
	String originalLanguage;
	String originalTitle;
	String overview;
	String posterPath;
	String releaseDate;
	String title;
	bool video;
	double voteAverage;
	int voteCount;
	double popularity;

	TrendingMovie(
			{this.adult,
				this.backdropPath,
				this.genreIds,
				this.id,
				this.originalLanguage,
				this.originalTitle,
				this.overview,
				this.posterPath,
				this.releaseDate,
				this.title,
				this.video,
				this.voteAverage,
				this.voteCount,
				this.popularity});

	TrendingMovie.fromJson(Map<String, dynamic> json) {
		adult = json['adult'];
		backdropPath = json['backdrop_path'];
		genreIds = json['genre_ids'].cast<int>();
		id = json['id'];
		originalLanguage = json['original_language'];
		originalTitle = json['original_title'];
		overview = json['overview'];
		posterPath = json['poster_path'];
		releaseDate = json['release_date'];
		title = json['title'];
		video = json['video'];
		voteAverage = json['vote_average'].toDouble();
		voteCount = json['vote_count'];
		popularity = json['popularity'].toDouble();
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['adult'] = this.adult;
		data['backdrop_path'] = this.backdropPath;
		data['genre_ids'] = this.genreIds;
		data['id'] = this.id;
		data['original_language'] = this.originalLanguage;
		data['original_title'] = this.originalTitle;
		data['overview'] = this.overview;
		data['poster_path'] = this.posterPath;
		data['release_date'] = this.releaseDate;
		data['title'] = this.title;
		data['video'] = this.video;
		data['vote_average'] = this.voteAverage;
		data['vote_count'] = this.voteCount;
		data['popularity'] = this.popularity;
		return data;
	}
}