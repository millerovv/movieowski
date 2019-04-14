import 'package:movieowski/src/model/api/response/base_movies_response.dart';

class SearchMoviesResponseRoot {
	int page;
	int totalResults;
	int totalPages;
	List<Movie> movies;

	SearchMoviesResponseRoot({this.page, this.totalResults, this.totalPages, this.movies});

	SearchMoviesResponseRoot.fromJson(Map<String, dynamic> json) {
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