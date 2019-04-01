import 'package:flutter/material.dart';
import 'package:movieowski/src/resources/api/tmdp_api_provider.dart';
import 'package:movieowski/src/utils/consts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeMovieCard extends StatelessWidget {
  static const double cardWidth = 139.0;
  static const double cardHeight = 214.3;

  final String posterPath;
  final bool forAndroid;
  final bool withRating;
  final bool asStubCard;
  final double rating;
  final String heroTag;

  HomeMovieCard({
    @required this.forAndroid,
    @required this.withRating,
    @required this.heroTag,
    this.asStubCard = false,
    this.posterPath = '',
    this.rating});

  @override
  Widget build(BuildContext context) {
    var ratingCircleRadius = 36.0;
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
                    child: Shimmer.fromColors(
                      baseColor: AppColors.lighterPrimary,
                      highlightColor: Colors.grey,
                      child: Container(
                        width: 131.0,
                        height: 196.3,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Container(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: 131.0,
                      height: 196.3,
                      child: Material(
                        color: Colors.transparent,
                        child: Hero(
                          tag: heroTag,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: !asStubCard ? FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
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
                          top: constraints.maxHeight - ratingCircleRadius,
                          left: constraints.maxWidth - ratingCircleRadius * 1,
                          child: Container(
                            width: ratingCircleRadius,
                            height: ratingCircleRadius,
                            decoration: BoxDecoration(
                              color: !asStubCard ? _calculateRatingColor(rating) : Colors.black,
                              shape: BoxShape.circle,
                              boxShadow: forAndroid
                                  ? <BoxShadow>[
                                      BoxShadow(
                                        color: Colors.black87,
                                        offset: Offset(1.0, 1.0),
                                        blurRadius: 4.0,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: !asStubCard ? Center(
                                child: Text(
                              rating.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .caption
                                  .copyWith(color: AppColors.primaryWhite, fontWeight: FontWeight.bold),
                            )) : SizedBox(),
                          ),
                        )
                      : SizedBox(),
                ],
              ),
        ),
      ),
    );
  }

  /// Get color for rating circle depending on rating value
  Color _calculateRatingColor(double rating) {
    if (rating >= 7.5) {
      return AppColors.accentColor;
    } else if (rating >= 6.5) {
      return AppColors.lightGreen;
    } else if (rating >= 5.5) {
      return AppColors.yellow;
    } else if (rating >= 4.5) {
      return AppColors.orange;
    } else {
      return AppColors.red;
    }
  }
}
