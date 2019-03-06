import 'dart:convert';
import 'dart:async';
import 'dart:io';

class BaseApiProvider {
	final HttpClient _httpClient = HttpClient();

	Future<String> getRequest(Uri uri) async {
		var request = await _httpClient.getUrl(uri);
		var response = await request.close();
		return response.transform(utf8.decoder).join();
	}
}