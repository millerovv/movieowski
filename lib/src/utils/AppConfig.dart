/// Class with app configuration info, such as API keys
class AppConfig {
  final String tmdbApiKey;

  AppConfig({this.tmdbApiKey = ""});

  factory AppConfig.fromJson(Map<String, dynamic> jsonMap) {
    return new AppConfig(tmdbApiKey: jsonMap["tmdb_api_key"]);
  }
}
