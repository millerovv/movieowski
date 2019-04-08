import 'package:flutter/material.dart';
import 'package:movieowski/src/resources/api/tmdp_api_provider.dart';
import 'package:movieowski/src/utils/consts.dart';
import 'package:movieowski/src/utils/ui_utils.dart';

class HomeMovieCard extends StatelessWidget {
  static const double cardWidth = 139.0;
  static const double cardHeight = 214.3;
  static const double ratingCircleDiameter = 36.0;

  final String posterPath;
  final bool withRating;
  final bool asStubCard;
  final double rating;
  final String imageHeroTag;
  final String ratingHeroTag;

  HomeMovieCard({
    @required this.withRating,
    @required this.imageHeroTag,
    this.ratingHeroTag,
    this.asStubCard = false,
    this.posterPath = '',
    this.rating});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Container(
        width: cardWidth, // Image container + 8dp
        height: cardHeight,
        child: LayoutBuilder(
          builder: (context, constraints) => Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: 131.0,
                      height: 196.3,
                      child: Material(
                        color: Colors.transparent,
                        child: Hero(
                          tag: imageHeroTag,
                          transitionOnUserGestures: true,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: !asStubCard ? FadeInImage.assetNetwork(
                              placeholder: 'assets/card_placeholder.png',
                              image: TmdbApiProvider.BASE_IMAGE_URL_W500 + posterPath,
                              fit: BoxFit.cover,
                            ) : Container(
                              width: 300.0,
                              height: 300.0,
                              decoration: BoxDecoration(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  withRating
                      ? Positioned(
                          top: constraints.maxHeight - ratingCircleDiameter,
                          left: constraints.maxWidth - ratingCircleDiameter * 1,
                          child: Material(
                            color: Colors.transparent,
                            child: Hero(
                              tag: ratingHeroTag,
                              transitionOnUserGestures: true,
                              child: Container(
                                width: ratingCircleDiameter,
                                height: ratingCircleDiameter,
                                decoration: BoxDecoration(
                                  color: !asStubCard ? calculateRatingColor(rating) : Colors.black,
                                  shape: BoxShape.circle,
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                      color: Colors.black87,
                                      offset: Offset(1.0, 1.0),
                                      blurRadius: 4.0,
                                    ),
                                  ],
                                ),
                                child: !asStubCard ? Center(
                                    child: Text(
                                      (rating != 0) ? rating.toString() : '–',
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption
                                      .copyWith(color: AppColors.primaryWhite, fontWeight: FontWeight.bold),
                                )) : SizedBox(),
                              ),
                            ),
                          ),
                        )
                      : SizedBox(),
                ],
              ),
        ),
      ),
    );
  }
}
