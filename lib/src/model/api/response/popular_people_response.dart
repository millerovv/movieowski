import 'package:movieowski/src/model/api/response/base_movies_response.dart';

class PopularPeopleResponseRoot {
	int page;
	int totalResults;
	int totalPages;
	List<Person> results;

	PopularPeopleResponseRoot({this.page, this.totalResults, this.totalPages, this.results});

	PopularPeopleResponseRoot.fromJson(Map<String, dynamic> json) {
		page = json['page'];
		totalResults = json['total_results'];
		totalPages = json['total_pages'];
		if (json['results'] != null) {
			results = new List<Person>();
			json['results'].forEach((v) {
				results.add(new Person.fromJson(v));
			});
		}
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['page'] = this.page;
		data['total_results'] = this.totalResults;
		data['total_pages'] = this.totalPages;
		if (this.results != null) {
			data['results'] = this.results.map((v) => v.toJson()).toList();
		}
		return data;
	}
}

class Person {
	double popularity;
	int id;
	String profilePath;
	String name;
	List<Movie> knownFor;
	bool adult;

	Person(
			{this.popularity,
				this.id,
				this.profilePath,
				this.name,
				this.knownFor,
				this.adult});

	Person.fromJson(Map<String, dynamic> json) {
		popularity = json['popularity'];
		id = json['id'];
		profilePath = json['profile_path'];
		name = json['name'];
		if (json['known_for'] != null) {
			knownFor = new List<Movie>();
			json['known_for'].forEach((v) {
				knownFor.add(new Movie.fromJson(v));
			});
		}
		adult = json['adult'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['popularity'] = this.popularity;
		data['id'] = this.id;
		data['profile_path'] = this.profilePath;
		data['name'] = this.name;
		if (this.knownFor != null) {
			data['known_for'] = this.knownFor.map((v) => v.toJson()).toList();
		}
		data['adult'] = this.adult;
		return data;
	}
}