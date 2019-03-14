import 'package:flutter/material.dart';
import 'package:movieowski/src/resources/api/tmdp_api_provider.dart';
import 'package:movieowski/src/utils/consts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeActorCard extends StatelessWidget {
  static const double cardWidth = 131.0;
  static const double cardHeight = 131.0;

  final bool asStubCard;
  final String posterPath;
  final String actorName;

  HomeActorCard({this.asStubCard = false, this.posterPath, this.actorName = "John Doe"});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Container(
        constraints: BoxConstraints(maxWidth: cardWidth, minHeight: 150, maxHeight: 180),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              width: cardWidth,
              height: cardHeight,
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
                        width: cardWidth,
                        height: cardHeight,
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
                      width: cardWidth,
                      height: cardHeight,
                      child: ClipOval(
                        child: !asStubCard
                            ? FadeInImage.memoryNetwork(
                                placeholder: kTransparentImage,
                                image: TmdbApiProvider.BASE_IMAGE_URL + posterPath,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                width: 300.0,
                                height: 300.0,
                                decoration: BoxDecoration(color: Colors.black),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 8.0),
              constraints: BoxConstraints(maxWidth: cardWidth, maxHeight: 140),
              child: !asStubCard
                  ? Text(
                      actorName,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.body1.copyWith(color: AppColors.primaryWhite),
                    )
                  : Text(
                      'jason statham',
                      style: Theme.of(context).textTheme.body1.copyWith(background: Paint()..color = Colors.black),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
