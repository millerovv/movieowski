import 'package:flutter/material.dart';

/// Base application class
class Movieowski extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movieowski',
      home: Scaffold(
        body: Center(
          child: Text('Hello world!'),
        ),
      ),
    );
  }
}
