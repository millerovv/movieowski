import 'package:movieowski/src/model/api/response/base_movies_response.dart';

class UpcomingMoviesResponseRoot extends BaseMoviesResponse {
	List<Movie> results;
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
			results = new List<Movie>();
			json['results'].forEach((v) {
				results.add(new Movie.fromJson(v));
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