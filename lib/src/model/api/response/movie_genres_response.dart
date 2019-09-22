import 'package:equatable/equatable.dart';

class MovieGenresResponseRoot {
	List<Genre> genres;

	MovieGenresResponseRoot({this.genres});

	MovieGenresResponseRoot.fromJson(Map<String, dynamic> json) {
		if (json['genres'] != null) {
			genres = new List<Genre>();
			json['genres'].forEach((v) {
				genres.add(new Genre.fromJson(v));
			});
		}
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		if (this.genres != null) {
			data['genres'] = this.genres.map((v) => v.toJson()).toList();
		}
		return data;
	}
}

class Genre extends Equatable {
	int id;
	String name;

	Genre({this.id, this.name}) : super([id, name]);

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['id'] = this.id;
		data['name'] = this.name;
		return data;
	}

	factory Genre.fromJson(Map<String, dynamic> json) {
		return Genre(id: json['id'], name: json['name']);
	}

	factory Genre.fromDbJson(Map<String, dynamic> json) {
		return Genre(id: json['api_id'], name: json['name']);
	}

	@override
  String toString() {
    return 'id = $id, name = $name';
  }
}