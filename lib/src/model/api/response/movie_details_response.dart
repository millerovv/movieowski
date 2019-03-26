class MovieDetailsResponseRoot {
	bool adult;
	String backdropPath;
	Null belongsToCollection;
	int budget;
	List<Genre> genres;
	String homepage;
	int id;
	String imdbId;
	String originalLanguage;
	String originalTitle;
	String overview;
	double popularity;
	String posterPath;
	List<ProductionCompany> productionCompanies;
	List<ProductionCountry> productionCountries;
	String releaseDate;
	int revenue;
	int runtime;
	List<SpokenLanguage> spokenLanguages;
	String status;
	String tagline;
	String title;
	bool video;
	double voteAverage;
	int voteCount;

	MovieDetailsResponseRoot(
			{this.adult,
				this.backdropPath,
				this.belongsToCollection,
				this.budget,
				this.genres,
				this.homepage,
				this.id,
				this.imdbId,
				this.originalLanguage,
				this.originalTitle,
				this.overview,
				this.popularity,
				this.posterPath,
				this.productionCompanies,
				this.productionCountries,
				this.releaseDate,
				this.revenue,
				this.runtime,
				this.spokenLanguages,
				this.status,
				this.tagline,
				this.title,
				this.video,
				this.voteAverage,
				this.voteCount});

	MovieDetailsResponseRoot.fromJson(Map<String, dynamic> json) {
		adult = json['adult'];
		backdropPath = json['backdrop_path'];
		belongsToCollection = json['belongs_to_collection'];
		budget = json['budget'];
		if (json['genres'] != null) {
			genres = new List<Genre>();
			json['genres'].forEach((v) {
				genres.add(new Genre.fromJson(v));
			});
		}
		homepage = json['homepage'];
		id = json['id'];
		imdbId = json['imdb_id'];
		originalLanguage = json['original_language'];
		originalTitle = json['original_title'];
		overview = json['overview'];
		popularity = json['popularity'];
		posterPath = json['poster_path'];
		if (json['production_companies'] != null) {
			productionCompanies = new List<ProductionCompany>();
			json['production_companies'].forEach((v) {
				productionCompanies.add(new ProductionCompany.fromJson(v));
			});
		}
		if (json['production_countries'] != null) {
			productionCountries = new List<ProductionCountry>();
			json['production_countries'].forEach((v) {
				productionCountries.add(new ProductionCountry.fromJson(v));
			});
		}
		releaseDate = json['release_date'];
		revenue = json['revenue'];
		runtime = json['runtime'];
		if (json['spoken_languages'] != null) {
			spokenLanguages = new List<SpokenLanguage>();
			json['spoken_languages'].forEach((v) {
				spokenLanguages.add(new SpokenLanguage.fromJson(v));
			});
		}
		status = json['status'];
		tagline = json['tagline'];
		title = json['title'];
		video = json['video'];
		voteAverage = json['vote_average'];
		voteCount = json['vote_count'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['adult'] = this.adult;
		data['backdrop_path'] = this.backdropPath;
		data['belongs_to_collection'] = this.belongsToCollection;
		data['budget'] = this.budget;
		if (this.genres != null) {
			data['genres'] = this.genres.map((v) => v.toJson()).toList();
		}
		data['homepage'] = this.homepage;
		data['id'] = this.id;
		data['imdb_id'] = this.imdbId;
		data['original_language'] = this.originalLanguage;
		data['original_title'] = this.originalTitle;
		data['overview'] = this.overview;
		data['popularity'] = this.popularity;
		data['poster_path'] = this.posterPath;
		if (this.productionCompanies != null) {
			data['production_companies'] =
					this.productionCompanies.map((v) => v.toJson()).toList();
		}
		if (this.productionCountries != null) {
			data['production_countries'] =
					this.productionCountries.map((v) => v.toJson()).toList();
		}
		data['release_date'] = this.releaseDate;
		data['revenue'] = this.revenue;
		data['runtime'] = this.runtime;
		if (this.spokenLanguages != null) {
			data['spoken_languages'] =
					this.spokenLanguages.map((v) => v.toJson()).toList();
		}
		data['status'] = this.status;
		data['tagline'] = this.tagline;
		data['title'] = this.title;
		data['video'] = this.video;
		data['vote_average'] = this.voteAverage;
		data['vote_count'] = this.voteCount;
		return data;
	}
}

class Genre {
	int id;
	String name;

	Genre({this.id, this.name});

	Genre.fromJson(Map<String, dynamic> json) {
		id = json['id'];
		name = json['name'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['id'] = this.id;
		data['name'] = this.name;
		return data;
	}
}

class ProductionCompany {
	int id;
	String logoPath;
	String name;
	String originCountry;

	ProductionCompany({this.id, this.logoPath, this.name, this.originCountry});

	ProductionCompany.fromJson(Map<String, dynamic> json) {
		id = json['id'];
		logoPath = json['logo_path'];
		name = json['name'];
		originCountry = json['origin_country'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['id'] = this.id;
		data['logo_path'] = this.logoPath;
		data['name'] = this.name;
		data['origin_country'] = this.originCountry;
		return data;
	}
}

class ProductionCountry {
	String iso31661;
	String name;

	ProductionCountry({this.iso31661, this.name});

	ProductionCountry.fromJson(Map<String, dynamic> json) {
		iso31661 = json['iso_3166_1'];
		name = json['name'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['iso_3166_1'] = this.iso31661;
		data['name'] = this.name;
		return data;
	}
}

class SpokenLanguage {
	String iso6391;
	String name;

	SpokenLanguage({this.iso6391, this.name});

	SpokenLanguage.fromJson(Map<String, dynamic> json) {
		iso6391 = json['iso_639_1'];
		name = json['name'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['iso_639_1'] = this.iso6391;
		data['name'] = this.name;
		return data;
	}
}