import 'package:flutter/material.dart';
import 'package:movieowski/src/resources/api/tmdp_api_provider.dart';
import 'package:movieowski/src/utils/consts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeMovieCard extends StatelessWidget {
  final String _posterPath;
  final double _rating;
  final bool _forAndroid;

  HomeMovieCard(this._posterPath, this._rating, this._forAndroid);

  @override
  Widget build(BuildContext context) {
    var iconSize = 36.0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Container(
        width: 147.0,
        height: 214.3,
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
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: TmdbApiProvider.BASE_IMAGE_URL + _posterPath,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: constraints.maxHeight - iconSize,
                    left: constraints.maxWidth - iconSize * 1.3,
                    child: Container(
                      width: iconSize,
                      height: iconSize,
                      decoration: BoxDecoration(
                        color: _calculateRatingColor(_rating),
                        shape: BoxShape.circle,
                        boxShadow: _forAndroid
                            ? <BoxShadow>[
                                BoxShadow(
                                  color: Colors.black87,
                                  offset: Offset(1.0, 1.0),
                                  blurRadius: 4.0,
                                ),
                              ]
                            : null,
                      ),
                      child: Center(
                          child: Text(
                        _rating.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .caption
                            .copyWith(color: AppColors.primaryWhite, fontWeight: FontWeight.bold),
                      )),
                    ),
                  )
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
