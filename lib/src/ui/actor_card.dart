import 'package:flutter/material.dart';
import 'package:movieowski/src/resources/api/tmdp_api_provider.dart';
import 'package:movieowski/src/utils/consts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeActorCard extends StatelessWidget {
  final String _posterPath;
  final String _actorName;

  HomeActorCard(this._posterPath, this._actorName);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Container(
        constraints: BoxConstraints(maxWidth: 131, minHeight: 180, maxHeight: 180),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              width: 131,
              height: 131,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Shimmer.fromColors(
                      baseColor: AppColors.lighterPrimary,
                      highlightColor: Colors.grey,
                      child: Container(
                        width: 131,
                        height: 131,
                        child: ClipOval(
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
                      width: 131,
                      height: 131,
                      child: ClipOval(
                        child: FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: TmdbApiProvider.BASE_IMAGE_URL + _posterPath,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 8.0),
              constraints: BoxConstraints(maxWidth: 131, maxHeight: 140),
              child: Text(
                _actorName,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.body1.copyWith(color: AppColors.primaryWhite),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
