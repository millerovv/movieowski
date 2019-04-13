import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:movieowski/src/utils/logger.dart';

class BaseApiProvider {
  final HttpClient _httpClient = HttpClient();

  Future<String> getRequest(Uri uri) async {
    Log.d('request/url = $uri', 'httpClient');
    var request = await _httpClient.getUrl(uri);
    var response = await request.close();
    var transformedResponse = await response.transform(utf8.decoder).join();
    if (response.statusCode == 200) {
      Log.d('response = ${transformedResponse.toString()}', 'httpClient');
      return transformedResponse;
    } else {
      throw ApiRequestFailedException(apiResponse: transformedResponse.toString());
    }
  }
}

abstract class ApiRequestException implements Exception {
  String message;
  ApiRequestException(this.message);
}

class ApiRequestFailedException extends ApiRequestException {
  String message;
  String apiResponse;
  ApiRequestFailedException({this.message = 'Problem connecting to the server', this.apiResponse = ''}) : super(message);
}

class NoInternetConnectionException extends ApiRequestException {
  String message;
  NoInternetConnectionException({this.message = 'No Internet connection'}) : super(message);
}