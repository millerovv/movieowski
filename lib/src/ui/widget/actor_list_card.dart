import 'package:flutter/material.dart';
import 'package:movieowski/src/ui/widget/actor_card.dart';
import 'package:movieowski/src/utils/consts.dart';
import 'package:movieowski/src/utils/ui_utils.dart';

class ActorListCard extends StatelessWidget {
  static const double cardHeight = 96;
  static const double backgroundHeight = 80;

  final String photoPath;
  final String name;
  final bool withHero;
  final String imageHeroTag;

  ActorListCard({
    Key key,
    this.photoPath,
    this.name,
    this.withHero = false,
    this.imageHeroTag = 'heroTag',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: cardHeight,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Align(
            alignment: Alignment.center,
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
              padding: const EdgeInsets.only(left: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black87,
                      offset: Offset(1.0, 1.0),
                      blurRadius: 4.0,
                    ),
                  ],
                ),
                child: heroWidget(
                    withHero,
                    imageHeroTag,
                    ActorCircleImage(
                      width: cardHeight,
                      posterPath: photoPath,
                      withName: false,
                    )),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0 + cardHeight + 24.0, right: 16.0),
              child: Text(name,
                  style: Theme.of(context)
                      .textTheme
                      .subhead
                      .copyWith(color: AppColors.primaryWhite, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }
}
