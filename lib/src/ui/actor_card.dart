import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeActorCard extends StatelessWidget {
  final String _posterPath;
  final String actorName;

  HomeActorCard(this._posterPath, this.actorName);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:8.0),
    );
  }
}
