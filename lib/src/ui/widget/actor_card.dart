import 'package:flutter/material.dart';
import 'package:movieowski/src/resources/api/tmdp_api_provider.dart';
import 'package:movieowski/src/utils/consts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeActorCircleImage extends StatelessWidget {
  static const double defaultWidth = 131.0;

  final double width;
  final bool asStubCard;
  final String posterPath;
  final String actorName;

  /// With additional information e.g character name under actor name
  final bool withSubTitle;
  final bool withShimmer;
  final String subTitle;

  HomeActorCircleImage({
    this.width = defaultWidth,
    this.asStubCard = false,
    this.posterPath,
    this.actorName = "John Doe",
    this.withSubTitle = false,
    this.withShimmer = true,
    this.subTitle
  });

  @override
  Widget build(BuildContext context) {
    return (asStubCard || (posterPath != null && posterPath.isNotEmpty)) ? Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Container(
        constraints: BoxConstraints(maxWidth: defaultWidth, minHeight: 150, maxHeight: 200),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              width: width,
              height: width,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  withShimmer ? Positioned(
                    top: 0,
                    left: 0,
                    child: Shimmer.fromColors(
                      baseColor: AppColors.lighterPrimary,
                      highlightColor: Colors.grey,
                      child: Container(
                        width: width,
                        height: width,
                        child: ClipOval(
                          child: Container(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ) : SizedBox(),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: width,
                      height: width,
                      child: ClipOval(
                        child: !asStubCard
                            ? FadeInImage.memoryNetwork(
                                placeholder: kTransparentImage,
                                image: '${TmdbApiProvider.BASE_IMAGE_URL_W300}$posterPath',
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
              constraints: BoxConstraints(maxWidth: width, maxHeight: 140),
              child: _createTitle(context),
            ),
          ],
        ),
      ),
    ) : SizedBox();
  }

  Widget _createTitle(BuildContext context) {
    if (!asStubCard && !withSubTitle) {
      return Text(
        actorName,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.body1.copyWith(color: AppColors.primaryWhite),
      );
    } else if (withSubTitle) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            actorName,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.body1.copyWith(color: AppColors.primaryWhite),
          ),
          SizedBox(
            height: 4.0,
          ),
          Text(
            (subTitle.length <= 60) ? subTitle : subTitle.substring(0, 60),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.caption.copyWith(color: AppColors.primaryWhite),
          )
        ],
      );
    } else {
      return Text(
        'jason statham',
        style: Theme.of(context).textTheme.body1.copyWith(background: Paint()..color = Colors.black),
      );
    }
  }
}
