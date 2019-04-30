import 'package:movieowski/src/model/api/response/base_movies_response.dart';

class TrendingMoviesResponseRoot extends BaseMoviesResponse {
	TrendingMoviesResponseRoot({page, movies, dates, totalPages, totalResults})
			: super(page: page, movies: movies, dates: dates, totalPages: totalPages, totalResults: totalResults);

	TrendingMoviesResponseRoot.fromJson(Map<String, dynamic> json) {
		page = json['page'];
		if (json['results'] != null) {
			movies = new List<Movie>();
			json['results'].forEach((v) {
				movies.add(new Movie.fromJson(v));
			});
		}
		totalPages = json['total_pages'];
		totalResults = json['total_results'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['page'] = this.page;
		if (this.movies != null) {
			data['results'] = this.movies.map((v) => v.toJson()).toList();
		}
		data['total_pages'] = this.totalPages;
		data['total_results'] = this.totalResults;
		return data;
	}
}