import 'package:movieowski/src/model/api/response/base_movies_response.dart';

class NowPlayingMoviesResponseRoot extends BaseMoviesResponse {
	int page;
	List<Movie> results;
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
			results = new List<Movie>();
			json['results'].forEach((v) {
				results.add(new Movie.fromJson(v));
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