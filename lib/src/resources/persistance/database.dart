import 'dart:async';

import 'package:movieowski/src/model/api/response/movie_genres_response.dart';
import 'package:movieowski/src/utils/logger.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
	DBProvider._();

	static final DBProvider dbProvider = DBProvider._();

	Database _database;

	Future<Database> get database async {
		if (_database != null) return _database;
		_database = await initDB();
		return _database;
	}

	Future<Database> initDB() async {
		var databasesPath = await getDatabasesPath();
		String path = join(databasesPath, "movieowski.db");
		return await openDatabase(path, version: 1, onOpen: (db) {},
				onCreate: (Database db, int version) async {
					await db.execute("CREATE TABLE Genres ("
							"id INTEGER PRIMARY KEY,"
							"api_id INTEGER,"
							"name TEXT,"
							"fetched_date_mills INTEGER"
							")");
				});
	}

	void insertGenres(List<Genre> genres) async {
		String values = "";
		for (Genre genre in genres) {
			values += '(${genre.id},\'${genre.name}\'}),';
		}
		values = values.substring(0, values.length-1);
		values += ';';
		Log.d('inserting values: $values', 'DB');
		final db = await database;
	  await db.rawInsert("INSERT INTO Genres (api_id, name, fetched_date_mills)"
			                " VALUES $values");
	}

	Future<List<Genre>> getAllGenres() async {
		final db = await database;
		var res = await db.query('Genres');
		final List<Genre> genres = res.isNotEmpty ? res.map((r) => Genre.fromJson(r)).toList() : [];
		return genres;
	}

	Future<int> deleteAllGenres() async {
		final db = await database;
		return db.rawDelete("Delete from Genres");
	}

	Future<void> dropDatabase() async {
		var databasesPath = await getDatabasesPath();
		String path = join(databasesPath, "movieowski.db");
		await deleteDatabase(path);
	}

	Future close() async => _database.close();
}