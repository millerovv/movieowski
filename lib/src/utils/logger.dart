import 'package:flutter/material.dart';

class Log {
	static void d(String log, [String key='i']) {
		debugPrint('DEBUG/$key: $log');
	}
	static void e(e, stacktrace) {
		debugPrint('ERROR: ${e.toString()}\n${stacktrace.toString()}');
	}
}