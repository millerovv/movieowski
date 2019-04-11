import 'package:flutter/material.dart';
import 'package:movieowski/src/ui/widget/movie_card.dart';
import 'package:movieowski/src/utils/consts.dart';
import 'package:movieowski/src/utils/ui_utils.dart';

class MovieListCard extends StatelessWidget {
  static const double listCardHeight = 152.0;
  static const double backgroundHeight = 136.0;
  static const double imageHeight = 144.0;
  static const double imageWidth = 96.1;

  final String posterPath;
  final double rating;
  final String title;
  final String releaseYear;
  final String genres;

  final bool withHero;
  final String imageHeroTag;
  final String ratingHeroTag;

  MovieListCard({
    Key key,
    this.posterPath,
    this.rating,
    this.title,
    this.releaseYear,
    this.genres,
    this.withHero = false,
    this.imageHeroTag = 'imageHero',
    this.ratingHeroTag = 'ratingHeroTag',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: listCardHeight,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: backgroundHeight,
              decoration: BoxDecoration(
                color: AppColors.lighterPrimary,
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black87,
                    offset: Offset(1.0, 1.0),
                    blurRadius: 2.0,
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0, left: 8.0),
              child: MovieCard(
                withRating: false,
                withHero: withHero,
                imageHeroTag: imageHeroTag,
                posterPath: posterPath,
                height: imageHeight,
                width: imageWidth,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0 + imageWidth + 16.0, top: 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(title, style: Theme.of(context).textTheme.body1.copyWith(
                      color: AppColors.primaryWhite, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4.0),
                  Text(releaseYear, style: Theme.of(context).textTheme.caption.copyWith(
                      color: AppColors.primaryWhite)),
                  SizedBox(height: 4.0),
                  Text(genres, style: Theme.of(context).textTheme.caption.copyWith(
                      color: AppColors.primaryWhite)),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0, right: 8.0),
              child: RatingCircle(
                withHero: withHero,
                heroTag: ratingHeroTag,
                rating: rating,
                color: calculateRatingColor(rating),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
