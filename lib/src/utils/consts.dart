import 'dart:ui';

import 'package:flutter/material.dart';

class Regions {
	Regions._internal();
	static const String RUSSIA = 'RU';
	static const String USA = 'US';
	static const String GERMANY = 'DE';
}

class Languages {
	Languages._internal();
	static const String ENGLISH = 'en-US';
}

class AppColors {
	AppColors._internal();
	static const Color primaryColor = Color(0xFF081B24);
	static const Color accentColor = Color(0xFF06D177);
	static const Color primaryWhite = Color(0xE6FFFFFF);
	static const Color hintGrey = Color(0xFF686868);
	static const Color hintWhite = Color(0xFFCCCCCC);
	static const Color lighterPrimary = Color(0xFF042F43);

	// Rating colors
	static const Color lightGreen = Color(0xFFB5D106);
	static const Color yellow = Color(0xFFD1CE06);
	static const Color orange = Color(0xFFD18606);
	static const Color red = Color(0xFFD13206);
}
