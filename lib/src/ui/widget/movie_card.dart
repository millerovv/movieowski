import 'package:flutter/material.dart';
import 'package:movieowski/src/resources/api/tmdp_api_provider.dart';
import 'package:movieowski/src/utils/consts.dart';
import 'package:movieowski/src/utils/ui_utils.dart';

class MovieCard extends StatelessWidget {
  static const double defaultImageWidth = 131.0;
  static const double defaultImageHeight = 196.3;

  final double height;
  final double width;
  final String posterPath;
  final bool withRating;
  final bool asStubCard;
  final double rating;
  final bool withHero;
  final String imageHeroTag;
  final String ratingHeroTag;

  MovieCard(
      {this.withRating = false,
      this.withHero = false,
      this.imageHeroTag,
      this.height = defaultImageHeight,
      this.width = defaultImageWidth,
      this.ratingHeroTag,
      this.asStubCard = false,
      this.posterPath = '',
      this.rating = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: withRating ? width + 8.0 : width,
      height: withRating ? height + 8.0 : height,
      child: LayoutBuilder(
        builder: (context, constraints) => Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    width: width,
                    height: height,
                    child: heroWidget(
                        withHero,
                        imageHeroTag,
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: !asStubCard
                              ? FadeInImage.assetNetwork(
                                  placeholder: 'assets/card_placeholder.png',
                                  image: TmdbApiProvider.BASE_IMAGE_URL_W500 + posterPath,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  width: 300.0,
                                  height: 300.0,
                                  decoration: BoxDecoration(color: Colors.black),
                                ),
                        )),
                  ),
                ),
                withRating
                    ? Positioned(
                        top: constraints.maxHeight - RatingCircle.defaultRatingCircleDiameter,
                        left: constraints.maxWidth - RatingCircle.defaultRatingCircleDiameter,
                        child: RatingCircle(
                          withHero: withHero,
                          rating: rating,
                          color: calculateRatingColor(rating),
                          heroTag: ratingHeroTag,
                        ),
                      )
                    : SizedBox(),
              ],
            ),
      ),
    );
  }
}

class RatingCircle extends StatelessWidget {
  static const double defaultRatingCircleDiameter = 36.0;

  final bool withHero;
  final double rating;
  final Color color;
  final String heroTag;
  final double diameter;

  RatingCircle({
    Key key,
    this.withHero = false,
    this.rating = 0,
    this.color = AppColors.hintGrey,
    this.heroTag = 'hero',
    this.diameter = defaultRatingCircleDiameter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return heroWidget(
        withHero,
        heroTag,
        Container(
            width: diameter,
            height: diameter,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black87,
                  offset: Offset(1.0, 1.0),
                  blurRadius: 4.0,
                ),
              ],
            ),
            child: Center(
                child: Text(
              (rating != 0) ? rating.toString() : '–',
              style: Theme.of(context)
                  .textTheme
                  .caption
                  .copyWith(color: AppColors.primaryWhite, fontWeight: FontWeight.bold),
            ))));
  }
}
