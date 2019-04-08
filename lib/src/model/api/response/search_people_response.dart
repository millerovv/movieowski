import 'package:movieowski/src/model/api/response/popular_people_response.dart';

class SearchPeopleResponseRoot {
	int page;
	int totalResults;
	int totalPages;
	List<Person> people;

	SearchPeopleResponseRoot({this.page, this.totalResults, this.totalPages, this.people});

	SearchPeopleResponseRoot.fromJson(Map<String, dynamic> json) {
		page = json['page'];
		totalResults = json['total_results'];
		totalPages = json['total_pages'];
		if (json['results'] != null) {
			people = new List<Person>();
			json['results'].forEach((v) {
				people.add(new Person.fromJson(v));
			});
		}
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['page'] = this.page;
		data['total_results'] = this.totalResults;
		data['total_pages'] = this.totalPages;
		if (this.people != null) {
			data['results'] = this.people.map((v) => v.toJson()).toList();
		}
		return data;
	}
}
