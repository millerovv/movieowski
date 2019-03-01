import 'dart:async' show Future;
import 'dart:convert' show json;
import 'package:flutter/services.dart' show rootBundle;
import 'package:movieowski/src/utils/app_config.dart';

/// Creates [AppConfig] with information from given json file
class AppConfigLoader {
  final String appConfigFilePath;

  AppConfigLoader({this.appConfigFilePath});

  Future<AppConfig> load() {
    return rootBundle.loadStructuredData<AppConfig>(this.appConfigFilePath,
        (jsonStr) async {
      final secret = AppConfig.fromJson(json.decode(jsonStr));
      return secret;
    });
  }
}
