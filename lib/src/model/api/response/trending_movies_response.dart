import 'package:movieowski/src/model/api/response/base_movies_response.dart';

class TrendingMoviesResponseRoot extends BaseMoviesResponse {
	int page;
	List<Movie> results;
	int totalPages;
	int totalResults;

	TrendingMoviesResponseRoot({this.page, this.results, this.totalPages, this.totalResults});

	TrendingMoviesResponseRoot.fromJson(Map<String, dynamic> json) {
		page = json['page'];
		if (json['results'] != null) {
			results = new List<Movie>();
			json['results'].forEach((v) {
				results.add(new Movie.fromJson(v));
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