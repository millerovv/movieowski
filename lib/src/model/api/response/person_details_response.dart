class PersonDetailsResponseRoot {
	String birthday;
	String knownForDepartment;
	String deathday;
	int id;
	String name;
	MovieCredits movieCredits;
	List<String> alsoKnownAs;
	int gender;
	String biography;
	double popularity;
	String placeOfBirth;
	String profilePath;
	bool adult;
	String imdbId;

	PersonDetailsResponseRoot(
			{this.birthday,
				this.knownForDepartment,
				this.deathday,
				this.id,
				this.name,
				this.movieCredits,
				this.alsoKnownAs,
				this.gender,
				this.biography,
				this.popularity,
				this.placeOfBirth,
				this.profilePath,
				this.adult,
				this.imdbId});

	PersonDetailsResponseRoot.fromJson(Map<String, dynamic> json) {
		birthday = json['birthday'];
		knownForDepartment = json['known_for_department'];
		deathday = json['deathday'];
		id = json['id'];
		name = json['name'];
		movieCredits = json['movie_credits'] != null
				? new MovieCredits.fromJson(json['movie_credits'])
				: null;
		alsoKnownAs = json['also_known_as'].cast<String>();
		gender = json['gender'];
		biography = json['biography'];
		popularity = json['popularity'];
		placeOfBirth = json['place_of_birth'];
		profilePath = json['profile_path'];
		adult = json['adult'];
		imdbId = json['imdb_id'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['birthday'] = this.birthday;
		data['known_for_department'] = this.knownForDepartment;
		data['deathday'] = this.deathday;
		data['id'] = this.id;
		data['name'] = this.name;
		if (this.movieCredits != null) {
			data['movie_credits'] = this.movieCredits.toJson();
		}
		data['also_known_as'] = this.alsoKnownAs;
		data['gender'] = this.gender;
		data['biography'] = this.biography;
		data['popularity'] = this.popularity;
		data['place_of_birth'] = this.placeOfBirth;
		data['profile_path'] = this.profilePath;
		data['adult'] = this.adult;
		data['imdb_id'] = this.imdbId;
		return data;
	}
}

class MovieCredits {
	List<Cast> cast;
	List<Crew> crew;

	MovieCredits({this.cast, this.crew});

	MovieCredits.fromJson(Map<String, dynamic> json) {
		if (json['cast'] != null) {
			cast = new List<Cast>();
			json['cast'].forEach((v) {
				cast.add(new Cast.fromJson(v));
			});
		}
		if (json['crew'] != null) {
			crew = new List<Crew>();
			json['crew'].forEach((v) {
				crew.add(new Crew.fromJson(v));
			});
		}
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		if (this.cast != null) {
			data['cast'] = this.cast.map((v) => v.toJson()).toList();
		}
		if (this.crew != null) {
			data['crew'] = this.crew.map((v) => v.toJson()).toList();
		}
		return data;
	}
}

class Cast {
	String posterPath;
	bool adult;
	String backdropPath;
	int voteCount;
	bool video;
	int id;
	double popularity;
	List<int> genreIds;
	String originalLanguage;
	String title;
	String originalTitle;
	String releaseDate;
	String character;
	double voteAverage;
	String overview;
	String creditId;

	Cast(
			{this.posterPath,
				this.adult,
				this.backdropPath,
				this.voteCount,
				this.video,
				this.id,
				this.popularity,
				this.genreIds,
				this.originalLanguage,
				this.title,
				this.originalTitle,
				this.releaseDate,
				this.character,
				this.voteAverage,
				this.overview,
				this.creditId});

	Cast.fromJson(Map<String, dynamic> json) {
		posterPath = json['poster_path'];
		adult = json['adult'];
		backdropPath = json['backdrop_path'];
		voteCount = json['vote_count'];
		video = json['video'];
		id = json['id'];
		var popularityDynamic = json['popularity'];
		popularity = (popularityDynamic is int) ? popularityDynamic.toDouble() : popularityDynamic;
		genreIds = json['genre_ids'].cast<int>();
		originalLanguage = json['original_language'];
		title = json['title'];
		originalTitle = json['original_title'];
		releaseDate = json['release_date'];
		character = json['character'];
		var voteAverageDynamic = json['vote_average'];
		voteAverage = (voteAverageDynamic is int) ? voteAverageDynamic.toDouble() : voteAverageDynamic;
		overview = json['overview'];
		creditId = json['credit_id'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['poster_path'] = this.posterPath;
		data['adult'] = this.adult;
		data['backdrop_path'] = this.backdropPath;
		data['vote_count'] = this.voteCount;
		data['video'] = this.video;
		data['id'] = this.id;
		data['popularity'] = this.popularity;
		data['genre_ids'] = this.genreIds;
		data['original_language'] = this.originalLanguage;
		data['title'] = this.title;
		data['original_title'] = this.originalTitle;
		data['release_date'] = this.releaseDate;
		data['character'] = this.character;
		data['vote_average'] = this.voteAverage;
		data['overview'] = this.overview;
		data['credit_id'] = this.creditId;
		return data;
	}
}

class Crew {
	int id;
	String department;
	String originalLanguage;
	String originalTitle;
	String job;
	String overview;
	List<int> genreIds;
	bool video;
	String creditId;
	String posterPath;
	double popularity;
	String backdropPath;
	int voteCount;
	String title;
	bool adult;
	double voteAverage;
	String releaseDate;

	Crew(
			{this.id,
				this.department,
				this.originalLanguage,
				this.originalTitle,
				this.job,
				this.overview,
				this.genreIds,
				this.video,
				this.creditId,
				this.posterPath,
				this.popularity,
				this.backdropPath,
				this.voteCount,
				this.title,
				this.adult,
				this.voteAverage,
				this.releaseDate});

	Crew.fromJson(Map<String, dynamic> json) {
		id = json['id'];
		department = json['department'];
		originalLanguage = json['original_language'];
		originalTitle = json['original_title'];
		job = json['job'];
		overview = json['overview'];
		genreIds = json['genre_ids'].cast<int>();
		video = json['video'];
		creditId = json['credit_id'];
		posterPath = json['poster_path'];
		var popularityDynamic = json['popularity'];
		popularity = (popularityDynamic is int) ? popularityDynamic.toDouble() : popularityDynamic;
		backdropPath = json['backdrop_path'];
		voteCount = json['vote_count'];
		title = json['title'];
		adult = json['adult'];
		var voteAverageDynamic = json['vote_average'];
		voteAverage = (voteAverageDynamic is int) ? voteAverageDynamic.toDouble() : voteAverageDynamic;
		releaseDate = json['release_date'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['id'] = this.id;
		data['department'] = this.department;
		data['original_language'] = this.originalLanguage;
		data['original_title'] = this.originalTitle;
		data['job'] = this.job;
		data['overview'] = this.overview;
		data['genre_ids'] = this.genreIds;
		data['video'] = this.video;
		data['credit_id'] = this.creditId;
		data['poster_path'] = this.posterPath;
		data['popularity'] = this.popularity;
		data['backdrop_path'] = this.backdropPath;
		data['vote_count'] = this.voteCount;
		data['title'] = this.title;
		data['adult'] = this.adult;
		data['vote_average'] = this.voteAverage;
		data['release_date'] = this.releaseDate;
		return data;
	}
}