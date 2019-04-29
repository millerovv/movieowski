import 'package:movieowski/src/model/api/response/base_movies_response.dart';

class PopularMoviesResponseRoot extends BaseMoviesResponse {
	int page;
	int totalResults;
	int totalPages;
	List<Movie> movies;

	PopularMoviesResponseRoot({this.page, this.totalResults, this.totalPages, this.movies});

	PopularMoviesResponseRoot.fromJson(Map<String, dynamic> json) {
		page = json['page'];
		totalResults = json['total_results'];
		totalPages = json['total_pages'];
		if (json['results'] != null) {
			movies = new List<Movie>();
			json['results'].forEach((v) {
				movies.add(new Movie.fromJson(v));
			});
		}
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['page'] = this.page;
		data['total_results'] = this.totalResults;
		data['total_pages'] = this.totalPages;
		if (this.movies != null) {
			data['results'] = this.movies.map((v) => v.toJson()).toList();
		}
		return data;
	}
}
