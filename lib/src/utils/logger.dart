import 'package:flutter/material.dart';

class Log {
	static void d(log, [key='i']) {
		debugPrint('DEBUG/$key: $log');
	}
	static void e(e, stacktrace) {
		debugPrint('ERROR: ${e.toString()}\n${stacktrace.toString()}');
	}
}