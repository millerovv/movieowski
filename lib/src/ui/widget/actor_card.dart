import 'package:flutter/material.dart';
import 'package:movieowski/src/resources/api/tmdp_api_provider.dart';
import 'package:movieowski/src/utils/consts.dart';
import 'package:movieowski/src/utils/ui_utils.dart';

class ActorCircleImage extends StatelessWidget {
  static const double defaultWidth = 131.0;

  final double width;
  final bool asStubCard;
  final String posterPath;
  final bool withName;
  final String actorName;

  /// With additional information e.g character name under actor name
  final bool withSubTitle;
  final String subTitle;

  final bool withHero;
  final String posterHeroTag;

  ActorCircleImage({
    this.width = defaultWidth,
    this.asStubCard = false,
    this.posterPath,
    this.withName = true,
    this.actorName = "John Doe",
    this.withSubTitle = false,
    this.subTitle,
    this.withHero = false,
    this.posterHeroTag = 'posterHeroTag',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: defaultWidth, minHeight: width, maxHeight: 200),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            width: width,
            height: width,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    width: width,
                    height: width,
                    child: heroWidget(
                        withHero,
                        posterHeroTag,
                        ClipOval(
                          child: (!asStubCard && posterPath != null && posterPath.isNotEmpty)
                              ? FadeInImage.assetNetwork(
                                  placeholder: 'assets/card_placeholder.png',
                                  image: '${TmdbApiProvider.BASE_IMAGE_URL_W500}$posterPath',
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  width: width,
                                  height: width,
                                  child: Image.asset('assets/person_placeholder.jpg', fit: BoxFit.cover)),
                        )),
                  ),
                ),
              ],
            ),
          ),
          (withName || withSubTitle)
              ? Container(
                  margin: EdgeInsets.only(top: 8.0),
                  constraints: BoxConstraints(maxWidth: width, maxHeight: 140),
                  child: _createTitle(context),
                )
              : SizedBox(),
        ],
      ),
    );
  }

  Widget _createTitle(BuildContext context) {
    if (!asStubCard) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          (withName)
              ? Text(
                  actorName,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.body1.copyWith(color: AppColors.primaryWhite),
                )
              : SizedBox(),
          SizedBox(
            height: 4.0,
          ),
          (withSubTitle)
              ? Text(
                  subTitle,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.caption.copyWith(color: AppColors.primaryWhite),
                )
              : SizedBox(),
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
